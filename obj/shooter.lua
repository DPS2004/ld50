Shooter = class('Shooter',Enemy)

function Shooter:initialize(params)
  
  Enemy.initialize(self,params)
  self.shoottimer = math.random(30,60)
end


function Shooter:update(dt)
  if self.shoottimer > 0 then
    self.shoottimer = self.shoottimer - dt
  else
    self.shoottimer = math.random(50,80)
    self:shoot()
  end
  self:bulletcheck()
  self:move()
  self:deathcheck()
end

function Shooter:draw()
  Enemy.draw(self)
  
end

return Shooter