Playerbullet = class('Playerbullet',Bullet)

function Playerbullet:initialize(params)
  
  Bullet.initialize(self,params)
  
  self.name = 'playerbullet'
  
  self.spr = sprites.playerbullet
  
  

end

function Playerbullet:update(dt)
  self:move(dt)
  self:checkwalls()
  
end


function Playerbullet:draw()
  color()
  if self.size == 2 then
    love.graphics.draw(self.spr,self.x,self.y,0,1,1,2,2)
  end
end

return Playerbullet