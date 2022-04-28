Enemybullet = class('Enemybullet',Bullet)

function Enemybullet:initialize(params)
  
  Bullet.initialize(self,params)
  
  self.name = 'enemybullet'
  
  self.isenemy = true
  
  
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
  if self.size == 2 then
    love.graphics.draw(self.spr,self.x,self.y,0,1,1,2,2)
  else
    love.graphics.setColor(1,58/255,153/255,1)
    love.graphics.setLineWidth(2)
    love.graphics.circle('line',self.x,self.y,self.size)
    love.graphics.setLineWidth(1)
    color()
  end
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