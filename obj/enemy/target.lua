Target = class('Target',Enemy)

function Target:initialize(params)
  
  Enemy.initialize(self,params)
  
  self.hp = 10
  
  self.hitbox = {x=self.x-5,y=self.y-5,width=10,height=10}
  self.size = 8
  
end


function Target:update(dt)
  prof.push("target update")
  self.hitbox = {x=self.x-5,y=self.y-5,width=10,height=10}
  
  self.ishit = false
  
  for i,v in ipairs(entities) do
    if v.name == 'playerbullet' then
      if helpers.distance({self.x,self.y},{v.x,v.y}) <= self.size then
        v.delete = true
        self:gethit(v)
      end
    end
    if v.name == 'thrownbox' then
      if helpers.distance({self.x,self.y},{v.x,v.y}) <= self.size+4 then
        if v:checkhit(o) then
          self:gethit(v,10)
          v:gethit(self)
        end
      end
    end
  end
  
  self:deathcheck()
  prof.pop("target update")
end

function Target:draw()
  prof.push("target draw")
  self:setshader()
  color()
  love.graphics.draw(sprites.target,self.x,self.y,0,1,1,8,8)
  self:endshader()
  prof.pop("target draw")
end

return Target