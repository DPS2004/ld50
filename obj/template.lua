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
  prof.push("example update")
  self.sinetimer = self.sinetimer + dt/60
  --self.r = math.sin(self.sinetimer)*20
  prof.pop("example update")
end

function Exampleentity:draw()
  prof.push("example draw")
  color('white')
  love.graphics.draw(self.spr,self.x,self.y,math.rad(self.r),1,1,45,45)
  prof.pop("example draw")
end

return Exampleentity