Floortile = class('Floortile',Entity)

function Floortile:initialize(params)
  
  self.layer = -10 -- lower layers draw first
  self.uplayer = 0 --lower uplayer updates first
  self.x = 0
  self.y = 0
  
  
  self.spr = sprites.floortile
  
  Entity.initialize(self,params)

end


function Floortile:update(dt)
end

function Floortile:draw()
  color()
  self.x = self.x % 40
  self.y = self.y % 60
  for x=-1,5 do
    for y=-1,4 do
      love.graphics.draw(self.spr,self.x+x*20,self.y+y*30)
    end
  end
end

return Floortile