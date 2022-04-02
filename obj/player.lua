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
  self.hitbox = {x=self.x,y=self.y,width=5,height=6}
  self.oldhitboxx = {x=self.x,y=self.y,width=5,height=6}
  self.oldhitboxy = {x=self.x,y=self.y,width=5,height=6}
  self.spr = ez.newanim(templates.player.base)
  
  Entity.initialize(self,params)

end


function Player:update(dt)
  if self.canmove then
    
    self.oldx = self.x 
    self.oldy = self.y
    
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
    
    
    local newx = self.x + self.cdx
    local newy = self.y + self.cdy
    
    self.hitbox.x = newx - 3
    self.hitbox.y = newy - 6
    
    self.oldhitboxx.x = self.x-3
    self.oldhitboxx.y = newy - 6
    
    self.oldhitboxy.x = newx - 3
    self.oldhitboxy.y = self.y-6
    
    local xok = true
    local yok = true
    for i,v in ipairs(cs.rooms.c.level.tiles) do
      if v.t == 0 then
        local blockhitbox = {x=v.x*8,y=v.y*8,width=8,height=8}
        if helpers.collide(self.hitbox,blockhitbox) then
          if helpers.collide(self.oldhitboxx,blockhitbox) then yok = false end
          if helpers.collide(self.oldhitboxy,blockhitbox) then xok = false end
        end
      end
    end
    
    
    if xok then self.x = newx else self.cdx = 0 end
    if yok then self.y = newy else self.cdy = 0 end
    
    
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
    
    ---room transitions
    if self.x < 8 then
      self.canmove = false
      flux.to(self, 30, {x=-9,y=64}):oncomplete(function() 
        self.x = 119 
        self.canmove = true 
        if cs.map[cs.croom].exits.l then
          cs.croom = cs.map[cs.croom].exits.l
          cs:updaterooms()
        end
      end)
      flux.to(cs.cube.r, 30, {y=63.5,z=0}):ease('outSine')
      
    end
    
    if self.x > 120 then
      self.canmove = false
      flux.to(self, 30, {x=128+9,y=64}):oncomplete(function() 
        self.x = 9
        self.canmove = true 
        if cs.map[cs.croom].exits.r then
          cs.croom = cs.map[cs.croom].exits.r
          cs:updaterooms()
        end
      end)
      flux.to(cs.cube.r, 30, {y=-63.5,z=0}):ease('outSine')
    end
    
    if self.y < 8 then
      self.canmove = false
      flux.to(self, 30, {x=64,y=-9}):oncomplete(function() 
        self.y = 119 
        self.canmove = true 
        if cs.map[cs.croom].exits.u then
          cs.croom = cs.map[cs.croom].exits.u
          cs:updaterooms()
        end
      end)
      flux.to(cs.cube.r, 30, {y=0,z=-63.5}):ease('outSine')
      
    end
    
    if self.y > 120 then
      self.canmove = false
      flux.to(self, 30, {x=64,y=128+9}):oncomplete(function() 
        self.y = 9
        self.canmove = true 
        if cs.map[cs.croom].exits.d then
          cs.croom = cs.map[cs.croom].exits.d
          cs:updaterooms()
        end
      end)
      flux.to(cs.cube.r, 30, {y=0,z=63.5}):ease('outSine')
    end
    
    
    
    cs.cube.r.y = (self.x - 64)*-0.5
    cs.cube.r.z = (self.y - 64)*0.5
    
  else
    
  end
  
  
  
end

function Player:drawmain(sx,sy)
  color()
  sx = sx or 0
  sy = sy or 0
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
    ez.drawframe(self.spr,0,self.x+dfx+sx,self.y+dfy+sy,0,1*flipscale,1,9,18)
    love.graphics.draw(self.gunspr,self.x+self.gunx+dfx+sx,self.y+self.guny+dfy-5+sy,0,gunflip,1,3,3)
  end,'white',true)
end

function Player:draw()
  
  self:drawmain(0,0)
  
  love.graphics.setCanvas(cs.cube.canvas.l)
  self:drawmain(128,0)
  
  love.graphics.setCanvas(cs.cube.canvas.r)
  self:drawmain(-128,0)
  
  love.graphics.setCanvas(cs.cube.canvas.u)
  self:drawmain(0,128)
  
  love.graphics.setCanvas(cs.cube.canvas.d)
  self:drawmain(0,-128)
  
end

return Player