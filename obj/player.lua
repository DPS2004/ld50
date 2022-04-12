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
  
  self.shootcooldown = 0
  self.gunx = 10
  self.guny = 0
  self.gunaimx = 10
  self.gunaimy = 0
  
  self.gunframe = 2
  
  self.gunspr = ez.newanim(templates.player.gun)
  
  self.speed = 1
  
  self.holding = 0
  
  self.throwx = 0
  self.throwy = 0
  self.throwhp = 0
  
  self.blockspr = ez.newanim(templates.block)
  
  self.hitcooldown = 0
  
  self.anim = 'idle'
  self.animframe = 0
  self.animtimer = 0
  self.nextanim = 'idle'
  
  self.canmove = true
  self.hitbox = {x=self.x,y=self.y,width=5,height=6}
  self.oldhitboxx = {x=self.x,y=self.y,width=5,height=6}
  self.oldhitboxy = {x=self.x,y=self.y,width=5,height=6}
  
  self.doortiles = {
    {x=6,y=0},{x=7,y=0},{x=8,y=0},{x=9,y=0},
    {x=6,y=15},{x=7,y=15},{x=8,y=15},{x=9,y=15},
    {x=0,y=6},{x=0,y=7},{x=0,y=8},{x=0,y=9},
    {x=15,y=6},{x=15,y=7},{x=15,y=8},{x=15,y=9},
  }
  
  self.spr = ez.newanim(templates.player.base)
  
  Entity.initialize(self,params)

end


function Player:update(dt)
  if self.shootcooldown > 0 then
    self.shootcooldown = self.shootcooldown - dt
  end
  
  if self.hitcooldown > 0 then
    self.hitcooldown = self.hitcooldown - dt*1.5
  end
  if self.hitcooldown < 0 then
    self.hitcooldown = 0
  end
  local moving = false
  
  if self.canmove then
    
    self.oldx = self.x 
    self.oldy = self.y
    
    self.dx = 0
    self.dy = 0
    
    if maininput:down('left') and (not maininput:down('right')) then
      self.flip = true
      self.dx = -self.speed
      moving = true
      
    end
    if maininput:down('right') and (not maininput:down('left')) then
      self.flip = false
      self.dx = self.speed
      moving = true
    end
    
    if maininput:down('up') and (not maininput:down('down')) then
      self.dy = -self.speed
      moving = true
    end
    if maininput:down('down') and (not maininput:down('up')) then
      self.dy = self.speed
      moving = true
    end
    local friction = 0.5
    self.cdx = (self.dx*friction +self.cdx)/(friction+1)
    self.cdy = (self.dy*friction +self.cdy)/(friction+1)
    
    
    local newx = self.x + self.cdx*dt
    local newy = self.y + self.cdy*dt
    
    self.hitbox.x = newx - 3
    self.hitbox.y = newy - 6
    
    self.oldhitboxx.x = self.x-3
    self.oldhitboxx.y = newy - 6
    
    self.oldhitboxy.x = newx - 3
    self.oldhitboxy.y = self.y-6
    
    
    local xok = true
    local yok = true
    local function sign(a) return a > 0 and 1 or -1 end

    for i,v in ipairs(cs.rooms.c.level.tiles) do
      if v.solid then
        local blockhitbox = {x=v.x*8,y=v.y*8,width=8,height=8}
        if helpers.collide(self.hitbox,blockhitbox) then
          
          if v.t == 2 then
            
            if self.holding == 0 and (maininput:down('shootleft') or maininput:down('shootright') or maininput:down('shootup') or maininput:down('shootdown')) then
              self.holding = 1
              
              
              
              self.gunx = (v.x*8 + 4) - self.x
              self.guny = (v.y*8 + 4) - (self.y+5)
              
              self.throwhp = v.hp
              
              table.remove(cs.rooms.c.level.tiles,i)
              
              print('picked up block, hp '..self.throwhp)
            end
          end
          
          if helpers.collide(self.oldhitboxx,blockhitbox) and sign(self.hitbox.y - blockhitbox.y) ~= sign(self.cdy)  then yok = false end
          if helpers.collide(self.oldhitboxy,blockhitbox) and sign(self.hitbox.x - blockhitbox.x) ~= sign(self.cdx) then xok = false end
        end
      end
    end
    
    if not cs.map[cs.croom].cleared and (cs.map[cs.croom].roomtype ~= 'boss') then
      for i,v in ipairs(cs.doortiles) do
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
      self.gunaimx = -11
    end
    if maininput:down('shootright') and (not maininput:down('shootleft')) then
      self.flip = false
      self.gunaimx = 11
    end
    
    if maininput:down('shootup') and (not maininput:down('shootdown')) then
      self.gunaimy = -11
    end
    if maininput:down('shootdown') and (not maininput:down('shootup')) then
      self.gunaimy = 11
    end
    
    --sprites
    
    if self.gunaimy < 0 then
      if self.gunaimx == 0 then
        self.gunframe = 0
      else
        self.gunframe = 1
      end
    elseif self.gunaimy > 0 then
      if self.gunaimx == 0 then
        self.gunframe = 4
      else
        self.gunframe = 3
      end
    else
      self.gunframe = 2
    end
    
    
    
    local doshoot = false
    if self.gunaimx == 0 and self.gunaimy == 0 then
      self.gunframe = 2
      if self.flip then 
        self.gunaimx = -10
      else
        self.gunaimx = 10
      end
    else
      doshoot = true
    end
    
    if self.gunaimy <= -9.5 then
      self.gunaimy = -9.5
    end
    
    self.gunaimx,self.gunaimy = helpers.circlimit(self.gunaimx,self.gunaimy,11)
    
    
    self.gunx = (self.gunx + self.gunaimx)/2
    self.guny = (self.guny + self.gunaimy)/2
    
    if doshoot and self.holding == 0 then
      if self.shootcooldown <= 0 then
        self.shootcooldown = 8
        em.init('playerbullet',{x=self.x+(self.gunx*0.85),y=self.y+(self.guny*0.85)-4,dx=self.gunaimx/4,dy=self.gunaimy/4,canv='c'})
        te.play('assets/sfx/player_shoot.ogg','static',{'player_shoot','sfx'},0.7)
      end
    end
    
    if self.holding ~= 0 then
      local tocollide = {}
      for i,v in ipairs(cs.rooms.c.level.tiles) do
        if v.solid then
          table.insert(tocollide,v)
        end
      end

      for i,v in ipairs(cs.doortiles) do
        table.insert(tocollide,v)
      end
      
      local dmove = helpers.rotate(1,helpers.anglepoints(0,0,self.gunx,self.guny),0,0)
      local dx,dy = dmove[1],dmove[2]
      local maxdistance = 0
      local dobreak = false
      for distance = 0, 400 do
        for i,v in ipairs(tocollide) do
          local blockhitbox = {x=v.x*8,y=v.y*8,width=8,height=8}
          if helpers.collide(blockhitbox,{x=(self.x + (dx * distance)) - 0.5,y=(self.y + (dy * distance)) - 5.5,width = 1,height = 1}) then
            if not dobreak then
              maxdistance = distance - 4 
              dobreak = true
            end
          end
          if dobreak then
            break
          end
        end
      end
      self.throwx = math.floor((self.x + (dx * maxdistance)) / 8)
      self.throwy = math.floor((self.y + (dy * maxdistance) - 5) / 8)
    end
    
    if maininput:pressed('accept') then
      if self.holding == 1 then
        
        local distance = helpers.distance({self.x,self.y-5},{self.throwx*8+5,self.throwy*8+5}) / 200
        local newbox = em.init('thrownbox',{
          x=self.x+self.gunx,
          y=self.y+self.guny-5,
          dx = self.gunx,
          dy = self.guny,
          hp=self.throwhp,
          canv = self.canv
        })
        
        rw:ease(0,distance,'linear',self.throwx*8+5,newbox,'x')
        rw:ease(0,distance,'linear',self.throwy*8+5,newbox,'y')
        rw:func(distance,function()
          if newbox and newbox.delete == false then
            if newbox.hp ~= 1 then
              newbox.delete = true
              table.insert(cs.rooms.c.level.tiles,{x=self.throwx,y=self.throwy,t=2,hp=newbox.hp-1,solid = true,drawflash = true})
            else
              newbox:destroy()
            end
          else
            newbox = nil
          end
        end)
        rw:play()
        
        self.holding = 0
      end
    end
    
    ---room transitions
    local movedistance = 14
    local cuberot = 66
    
    if self.x < 8 then
      self.canmove = false
      flux.to(self, 30, {x=(0-movedistance),y=64}):oncomplete(function() 
        self.x = 128-movedistance
        self.canmove = true 
        if cs.map[cs.croom].exits.l then
          cs.croom = cs.map[cs.croom].exits.l
          cs:updaterooms()
        end
      end)
      flux.to(cs.cube.r, 30, {y=cuberot,z=0}):ease('outSine')
      te.play('assets/sfx/cube_rotate.ogg','static',{'cube_rotate','sfx'},0.5)
      
    end
    
    if self.x > 120 then
      self.canmove = false
      flux.to(self, 30, {x=128+movedistance,y=64}):oncomplete(function() 
        self.x = movedistance
        self.canmove = true 
        if cs.map[cs.croom].exits.r then
          cs.croom = cs.map[cs.croom].exits.r
          cs:updaterooms()
        end
      end)
      flux.to(cs.cube.r, 30, {y=(0-cuberot),z=0}):ease('outSine')
      te.play('assets/sfx/cube_rotate.ogg','static',{'cube_rotate','sfx'},0.5)
    end
    
    if self.y < 8 then
      self.canmove = false
      flux.to(self, 30, {x=64,y=(0-movedistance)}):oncomplete(function() 
        self.y = 128-movedistance
        self.canmove = true 
        if cs.map[cs.croom].exits.u then
          cs.croom = cs.map[cs.croom].exits.u
          cs:updaterooms()
        end
      end)
      flux.to(cs.cube.r, 30, {y=0,z=(0-cuberot)}):ease('outSine')
      te.play('assets/sfx/cube_rotate.ogg','static',{'cube_rotate','sfx'},0.5)
      
    end
    
    if self.y > 120 then
      self.canmove = false
      flux.to(self, 30, {x=64,y=128+movedistance}):oncomplete(function() 
        self.y = movedistance
        self.canmove = true 
        if cs.map[cs.croom].exits.d then
          cs.croom = cs.map[cs.croom].exits.d
          cs:updaterooms()
        end
      end)
      flux.to(cs.cube.r, 30, {y=0,z=cuberot}):ease('outSine')
      te.play('assets/sfx/cube_rotate.ogg','static',{'cube_rotate','sfx'},0.5)
    end
    
    
    
    cs.cube.r.y = (self.x - 64)*-0.5
    cs.cube.r.z = (self.y - 64)*0.5
    
    
  else
    moving = true
  end
  cs.cube:updateRotation()
  if self.hitcooldown == 0 then
    self.hitbox.height = 8
    self.hitbox.y = self.hitbox.y - 2
  
    for i,v in ipairs(entities) do
      if v.isenemy then
        if helpers.collide(self.hitbox,v.hitbox) then
          self.hitcooldown = 89
          cs:addscore(-200,'gothit')
          te.play('assets/sfx/player_hit.ogg','static',{'player_hit','sfx'},1)
          self.anim = 'hit'
          self.animtimer = 30
          self.nextanim = 'idle'
        end
      end
    end
    
    self.hitbox.height = 6
    self.hitbox.y = self.hitbox.y + 2
    
  end
  
  if self.anim == 'hit' then
    self.frame = 2
  elseif self.anim == 'idle' then
    self.frame = 0
    if moving then
      self.anim = 'moving'
      self.frame = 1
      self.nextanim = 'moving'
      self.animtimer = 10
    end
  end
  
  if self.anim == 'moving' then
    if not moving then
      self.anim = 'idle'
      self.nextanim = 'idle'
      self.frame = 0
    end
  end
  
  self.animtimer = self.animtimer - dt
  if self.animtimer <= 0 then
    if self.nextanim == 'idle' then
      self.frame = 0
      self.anim = 'idle'
    elseif self.nextanim == 'moving' then
      self.frame = (self.frame + 1)%2
      self.animtimer = 10
    end
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
  if math.floor(self.hitcooldown / 10) % 2 == 0 then
    helpers.drawbordered(function(dfx,dfy)
      ez.drawframe(self.spr,self.frame,self.x+dfx+sx,self.y+dfy+sy,0,1*flipscale,1,9,18)
      if self.holding == 0 then
        ez.drawframe(self.gunspr,self.gunframe,self.x+self.gunx+dfx+sx-0.5,self.y+self.guny+dfy-5+sy,0,gunflip,1,4,5)
      end
    end,'white',true)
    
    color()
    if self.holding == 1 then
      ez.drawframe(self.blockspr,4-self.throwhp,self.x+self.gunx+sx,self.y+self.guny+sy-5,0,1,1,5,5)
      love.graphics.draw(sprites.throwcursor,self.throwx*8+5+sx,self.throwy*8+5+sy,0,1,1,5,5)
    end
    
    
    
    
    color()
  end
  
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