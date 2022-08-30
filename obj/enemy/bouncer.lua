Bouncer = class('Bouncer',Enemy)

function Bouncer:initialize(params)
  
  Enemy.initialize(self,params)
  
  self.spr = sprites.bouncer
end


function Bouncer:update(dt)
  prof.push("bouncer update")
  local ang = helpers.rotate(1,self.angle,0,0)
  self.dx = ang[1]
  self.dy = ang[2]
  self:bulletcheck()
  self:move(dt,{bounce = true,knockback = 0})
  self:deathcheck()
  prof.pop("bouncer update")
  
end

function Bouncer:draw()
  prof.push("bouncer draw")
  self:setshader()
  love.graphics.draw(self.spr,self.x,self.y,0,1,1,5,5)
  self:endshader()
  prof.pop("bouncer draw")
end

return Bouncer