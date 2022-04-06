Walker = class('Walker',Enemy)

function Walker:initialize(params)
  
  Enemy.initialize(self,params)
  
  self.spr = sprites.walker
  self.flipped = math.random(0,1)*2-1
  self.flippedtimer = math.random(10,30)
end


function Walker:update(dt)
  
  local ang = helpers.rotate(0.5,helpers.anglepoints(self.x,self.y,cs.player.x,cs.player.y - 3),0,0)
  self.dx = ang[1]
  self.dy = ang[2]
  self:bulletcheck()
  self:move(dt)
  self:deathcheck()
  self.flippedtimer = self.flippedtimer - dt
  if self.flippedtimer <= 0 then
    self.flippedtimer = 25
    self.flipped = self.flipped * -1
  end
end

function Walker:draw()
  self:setshader()
  love.graphics.draw(self.spr,self.x,self.y,0,self.flipped,1,5,5)
  self:endshader()
end

return Walker