Player = class('Player',Entity)

function Player:initialize(params)
  
  self.layer = 10 -- lower layers draw first
  self.uplayer = 0 --lower uplayer updates first
  self.x = 0
  self.y = 0
  
  self.cdx = 0
  self.cdy = 0
  self.dx = 0
  self.dy = 0
  self.flip = false
  
  self.speed = 1
  
  self.canmove = true
  
  self.spr = ez.newanim(templates.player.base)
  
  Entity.initialize(self,params)

end


function Player:update(dt)
  if self.canmove then
    self.dx = 0
    self.dy = 0
    if maininput:down('left') and (not maininput:down('right')) then
      self.flip = true
      self.dx = -self.speed
    end
    if maininput:down('right') and (not maininput:down('left')) then
      self.flip = false
      self.dx = self.speed
    end
    
    if maininput:down('up') and (not maininput:down('down')) then
      self.dy = -self.speed
    end
    if maininput:down('down') and (not maininput:down('up')) then
      self.dy = self.speed
    end
    local friction = 0.5
    self.cdx = (self.dx*friction +self.cdx)/(friction+1)
    self.cdy = (self.dy*friction +self.cdy)/(friction+1)
    self.x = self.x + self.cdx
    self.y = self.y + self.cdy
      
  end
  
  cs.cube.r.y = (self.x - 64)*-0.5
  cs.cube.r.z = (self.y - 64)*0.5
  
end

function Player:draw()
  color()
  local flipscale = 1
  local flipoffset = 1
  if self.flip then
    flipscale = -1
  end
  
  ez.drawframe(self.spr,0,self.x,self.y,0,1*flipscale,1,9,18)
end

return Player