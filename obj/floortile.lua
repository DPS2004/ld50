Floortile = class('Floortile',Entity)

function Floortile:initialize(params)
  
  self.layer = -10 -- lower layers draw first
  self.uplayer = 0 --lower uplayer updates first
  self.x = 0
  self.y = 0
  
  self.level = nil
  
  self.spr = sprites.floortile
  self.sprdark = sprites.floortiledark
  
  Entity.initialize(self,params)

end


function Floortile:update(dt)
end

function Floortile:draw()
  color()
  self.x = self.x % 40
  self.y = self.y % 60
  local drawspr = self.sprdark
  
  if self.level then
    if self.level.cleared then
      drawspr = self.spr
    end
    if self.level.ruined then
      color('black')
    end
  end
  
  for x=-1,5 do
    for y=-1,4 do
      love.graphics.draw(drawspr,self.x+x*20,self.y+y*30)
    end
  end
end

return Floortile