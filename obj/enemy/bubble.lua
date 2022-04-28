Bubble = class('Bubble',Enemy)

function Bubble:initialize(params)
  
  self.basesize = 8
  params.hbsize = params.hbsize or 5
  Enemy.initialize(self,params)
  
  self.hp = 15
  
  self.hitbox = {x=self.x-5,y=self.y-5,width=10,height=10}
  
  self.pulsei = 0
  self.size = self.basesize
  
end


function Bubble:update(dt)
  
  self.hitbox = {x=self.x-5,y=self.y-5,width=10,height=10}
  
  self.pulsei = self.pulsei + dt/20
  self.size = self.basesize + math.sin(self.pulsei)
  
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
  
end

function Bubble:draw()
  self:setshader()
  love.graphics.setColor(1,58/255,153/255,1)
  love.graphics.circle('line',self.x,self.y,self.size)
  color()
  self:endshader()
end

return Bubble