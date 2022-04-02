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
  
  self.gunx = 10
  self.guny = 0
  self.gunaimx = 10
  self.gunaimy = 0
  
  self.gunspr = sprites.gun
  
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
    
    
    self.gunaimx = 0
    self.gunaimy = 0
    if maininput:down('shootleft') and (not maininput:down('shootright')) then
      self.flip = true
      self.gunaimx = -10
    end
    if maininput:down('shootright') and (not maininput:down('shootleft')) then
      self.flip = false
      self.gunaimx = 10
    end
    
    if maininput:down('shootup') and (not maininput:down('shootdown')) then
      self.gunaimy = -10
    end
    if maininput:down('shootdown') and (not maininput:down('shootup')) then
      self.gunaimy = 10
    end
    
    if self.gunaimx == 0 and self.gunaimy == 0 then
      if self.flip then 
        self.gunaimx = -10
      else
        self.gunaimx = 10
      end
    end
    self.gunx = (self.gunx + self.gunaimx)/2
    self.guny = (self.guny + self.gunaimy)/2
    
    
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
  
  local gunflip = 1
  if self.gunx <=0 then
    gunflip = -1
  end
  helpers.drawbordered(function(dfx,dfy)
    ez.drawframe(self.spr,0,self.x+dfx,self.y+dfy,0,1*flipscale,1,9,18)
    love.graphics.draw(self.gunspr,self.x+self.gunx+dfx,self.y+self.guny+dfy-5,0,gunflip,1,3,3)
  end,'white',true)
end

return Player