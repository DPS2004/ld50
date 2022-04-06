Bubble = class('Bubble',Enemy)

function Bubble:initialize(params)
  
  self.basesize = 8
  Enemy.initialize(self,params)
  
  self.hp = 20
  
  self.hitbox = {x=self.x-5,y=self.y-5,width=10,height=10}
  self.pulsei = 0
  self.size = self.basesize
  
end


function Bubble:update(dt)
  
  self.hitbox = {x=self.x-5,y=self.y-5,width=10,height=10}
  
  self.pulsei = self.pulsei + dt/20
  self.size = self.basesize + math.sin(self.pulsei)
  
  for i,v in ipairs(entities) do
    if v.name == 'playerbullet' then
      if helpers.distance({self.x,self.y},{v.x,v.y}) <= self.size then
        v.delete = true
        self.hp = self.hp - 1
        if self.hp > 0 then 
          te.play('assets/sfx/enemy_hit.ogg','static',{'enemy_hit','sfx'},0.9)
          self.ishit = true
        else
          te.play('assets/sfx/enemy_die.ogg','static',{'enemy_hit','sfx'},1)
          cs:addscore(25,'killedenemy')
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