Playerbullet = class('Playerbullet',Bullet)

function Playerbullet:initialize(params)
  
  Bullet.initialize(self,params)
  
  self.name = 'playerbullet'
  
  self.spr = sprites.playerbullet
  
  self.hitbox = {x=0,y=0,width=4,height=4}

end

function Playerbullet:update(dt)
  self:move(dt)
  self:checkwalls()
  
end


function Playerbullet:draw()
  color()
  love.graphics.draw(self.spr,self.x,self.y,0,1,1,2,2)
end

return Playerbullet