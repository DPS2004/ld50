Bouncer = class('Bouncer',Enemy)

function Bouncer:initialize(params)
  
  Enemy.initialize(self,params)
  
  self.spr = sprites.bouncer
end


function Bouncer:update(dt)
  
  local ang = helpers.rotate(1,self.angle,0,0)
  self.dx = ang[1]
  self.dy = ang[2]
  self:bulletcheck()
  self:move(dt,{bounce = true,knockback = 0})
  self:deathcheck()
  
end

function Bouncer:draw()
  love.graphics.draw(self.spr,self.x,self.y,0,1,1,5,5)
  
end

return Bouncer