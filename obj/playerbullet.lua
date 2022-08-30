Playerbullet = class('Playerbullet',Bullet)

function Playerbullet:initialize(params)
  
  Bullet.initialize(self,params)
  
  self.name = 'playerbullet'
  
  self.spr = sprites.playerbullet
  
  

end

function Playerbullet:update(dt)
  
  prof.push("player bullet update")
  Bullet.update(self,dt)
  prof.pop("player bullet update")
  
end


function Playerbullet:draw()
  prof.push("player bullet draw")
  Bullet.draw(self)
  prof.pop("player bullet draw")
end

return Playerbullet