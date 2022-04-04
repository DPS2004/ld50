SpinnerOrbiter = class('SpinnerOrbiter',Enemy)

function SpinnerOrbiter:initialize(params)
  
  Enemy.initialize(self,params)
  
  self.hp = 20
  
  self.size = 4
  
  self.uplayer = 2
  
  self.skiprender = true
  self.skipupdate = true
  
  self.hitbox = {x=0,y=0,width=8,height=8}
end

function SpinnerOrbiter:updatehitbox()
  self.hitbox.x = self.x - 4
  self.hitbox.y = self.y - 4
end

function SpinnerOrbiter:update(dt)
  
  
  self:bulletcheck()
  self:move(dt,{movehx=self.parentspinner,dontmove = true})
  self:deathcheck()
  
end

function SpinnerOrbiter:draw()
  
  love.graphics.setColor(1,58/255,153/255,1)
  love.graphics.circle('fill',self.x,self.y,self.size)
  color()
  love.graphics.circle('line',self.x,self.y,self.size)
  
  
end

return SpinnerOrbiter