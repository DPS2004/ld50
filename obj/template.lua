Exampleentity = class('Exampleentity',Entity)

function Exampleentity:initialize(params)
  
  self.layer = 0 -- lower layers draw first
  self.uplayer = 0 --lower uplayer updates first
  self.x = 0
  self.y = 0
  
  self.sinetimer = 0
  
  self.r = 0
  
  self.spr = sprites.cobblestone
  
  Entity.initialize(self,params)

end


function Exampleentity:update(dt)
  self.sinetimer = self.sinetimer + dt/60
  --self.r = math.rad(math.sin(self.sinetimer)*20)
end

function Exampleentity:draw()
  color('white')
  love.graphics.draw(self.spr,self.x,self.y,self.r,1,1,45,45)
end

return Exampleentity