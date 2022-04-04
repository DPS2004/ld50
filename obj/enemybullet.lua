Enemybullet = class('Enemybullet',Bullet)

function Enemybullet:initialize(params)
  
  Bullet.initialize(self,params)
  
  self.name = 'enemybullet'
  
  self.isenemy = true
  
  self.hitbox = {x=0,y=0,width=4,height=4}

end

function Enemybullet:update()
  self:move()
  self:checkwalls()
  
end


function Enemybullet:draw()
  color()
  love.graphics.draw(self.spr,self.x,self.y,0,1,1,2,2)
end

return Enemybullet