Enemybullet = class('Enemybullet',Bullet)

function Enemybullet:initialize(params)
  
  Bullet.initialize(self,params)
  
  self.name = 'enemybullet'
  
  self.isenemy = true
  
  self.hitbox = {x=0,y=0,width=4,height=4}
  if type(self.canv) == 'string' then
    self.canv = cs.cube.canvas[self.canv]
  end
end

function Enemybullet:update(dt)
  self:move(dt)
  self:checkwalls()
  
end


function Enemybullet:drawt()
  color()
  love.graphics.draw(self.spr,self.x,self.y,0,1,1,2,2)
end

function Enemybullet:draw()
  if self.all_canv then
    for _, c in pairs(cs.cube.canvas) do
      love.graphics.setCanvas(c)
      self:drawt()
    end
  else
    love.graphics.setCanvas(self.canv)
    self:drawt()
  end
end

return Enemybullet