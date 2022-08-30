Walkshoot = class('Walkshoot',Enemy)

function Walkshoot:initialize(params)
  
  Enemy.initialize(self,params)
  
  self.spr = sprites.walkshoot
  self.flipped = math.random(0,1)*2-1
  self.flippedtimer = math.random(10,30)
  self.angle = math.random(0,359)
  self.anglechange = math.random(30,200)
  
  self.shoottimer = math.random(100,200)
end


function Walkshoot:update(dt)
  prof.push("walkshoot update")
  self.anglechange = self.anglechange - dt
  if self.anglechange <= 0 then
    self.anglechange = math.random(30,200)
    self.angle = math.random(0,359)
  end
  
  local ang = helpers.rotate(0.4,self.angle,0,0)
  self.dx = ang[1]
  self.dy = ang[2]
  
  if self.shoottimer > 0 then
    self.shoottimer = self.shoottimer - dt
  else
    self.shoottimer = math.random(150,250)
    self:shoot()
  end
  
  self:bulletcheck()
  self:move(dt)
  self:deathcheck()
  
  
  self.flippedtimer = self.flippedtimer - dt
  if self.flippedtimer <= 0 then
    self.flippedtimer = 25
    self.flipped = self.flipped * -1
  end
  prof.pop("walkshoot update")
  
end

function Walkshoot:draw()
  prof.push("walkshoot update")
  self:setshader()
  love.graphics.draw(self.spr,self.x,self.y,0,self.flipped,1,5,5)
  self:endshader()
  prof.pop("walkshoot update")
end

return Walkshoot