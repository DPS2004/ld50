Shooter = class('Shooter',Enemy)

function Shooter:initialize(params)
  
  Enemy.initialize(self,params)
  
end


function Shooter:update(dt)
  
end

function Shooter:draw()
  Enemy.draw(self)
  
end

return Shooter