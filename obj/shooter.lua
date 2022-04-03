Shooter = class('Shooter',Enemy)

function Shooter:initialize(params)
  
  Enemy.initialize(self,params)
  
end


function Shooter:update(dt)
  self:bulletcheck()
  self:move()
  self:deathcheck()
end

function Shooter:draw()
  Enemy.draw(self)
  
end

return Shooter