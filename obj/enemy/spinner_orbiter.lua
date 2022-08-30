SpinnerOrbiter = class('SpinnerOrbiter',Enemy)

function SpinnerOrbiter:initialize(params)
  
  
  params.hbsize = params.hbsize or 4
  Enemy.initialize(self,params)
  
  self.hp = 20
  
  self.size = 4
  
  self.uplayer = 2
  
  self.skiprender = true
  self.skipupdate = true
  
  self.hitbox = {x=0,y=0,width=8,height=8}
end



function SpinnerOrbiter:update(dt)
  prof.push("spinner orbiter update")
  self:bulletcheck()
  self:move(dt,{movehx=self.parentspinner,dontmove = true})
  self:deathcheck()
  prof.pop("spinner orbiter update")
end

function SpinnerOrbiter:draw()
  prof.push("spinner orbiter draw")
  self:setshader()
  love.graphics.setColor(1,58/255,153/255,1)
  love.graphics.circle('fill',self.x,self.y,self.size)
  color()
  love.graphics.circle('line',self.x,self.y,self.size)
  self:endshader()
  prof.pop("spinner orbiter draw")
end

return SpinnerOrbiter