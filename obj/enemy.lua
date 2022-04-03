Enemy = class('Enemy',Entity)

function Enemy:initialize(params)
  
  self.layer = 11 -- lower layers draw first
  self.uplayer = 0 --lower uplayer updates first
  self.x = 0
  self.y = 0
  self.size = 5
  self.spr = sprites.enemyface
  
  self.hitbox = {x=0,y=0,width=8,height=8}
  
  Entity.initialize(self,params)
  
end


function Enemy:update(dt)
  
end

function Enemy:draw()
  love.graphics.setColor(1,58/255,153/255,1)
  love.graphics.circle('fill',self.x,self.y,self.size)
  color()
  love.graphics.draw(self.spr, self.x - 3.5, self.y -1.5)
  
end

return Enemy