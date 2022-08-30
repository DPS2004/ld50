Shooter = class('Shooter',Enemy)

function Shooter:initialize(params)
  
  Enemy.initialize(self,params)
  self.shoottimer = math.random(30,60)
end


function Shooter:update(dt)
  prof.push("shooter update")
  if self.shoottimer > 0 then
    self.shoottimer = self.shoottimer - dt
  else
    self.shoottimer = math.random(50,80)
    self:shoot()
  end
  self:bulletcheck()
  self:move(dt)
  self:deathcheck()
  prof.pop("shooter update")
end

function Shooter:draw()
  prof.push("shooter draw")
  Enemy.draw(self)
  prof.pop("shooter draw")
  
end

return Shooter