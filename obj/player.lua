Player = class('Player',Entity)

function Player:initialize(params)

  self.gunTypes = { -- haha enumerators
    pistol = 1,
    laser = 2,
    sword = 3
  }
  
  self.layer = 10 -- lower layers draw first
  self.uplayer = 0 --lower uplayer updates first
  self.x = 0
  self.y = 0
  
  self.cdx = 0
  self.cdy = 0
  self.dx = 0
  self.dy = 0
  self.flip = false
  
  self.gun = self.gunTypes.pistol
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
  self.invalidthrow = false
  
  self.throwhp = 0
  
  self.boxspr = ez.newanim(templates.box)
  
  self.hitcooldown = 0
  
  self.anim = 'idle'
  self.animframe = 0
  self.animtimer = 0
  self.nextanim = 'idle'
  
  self.canmove = true
  self.hitbox = {x=self.x,y=self.y,width=5,height=6}
  self.oldhitboxx = {x=self.x,y=self.y,width=5,height=6}
  self.oldhitboxy = {x=self.x,y=self.y,width=5,height=6}
  
  self.blocking = false
  self.speedcooldown = 0
  self.blockcooldown = 0
  self.blockanim = 0
  
  self.speedpenalty = 30
  self.blockpenalty = 60
  
  self.doortiles = {
    {x=6,y=0},{x=7,y=0},{x=8,y=0},{x=9,y=0},
    {x=6,y=15},{x=7,y=15},{x=8,y=15},{x=9,y=15},
    {x=0,y=6},{x=0,y=7},{x=0,y=8},{x=0,y=9},
    {x=15,y=6},{x=15,y=7},{x=15,y=8},{x=15,y=9},
  }
  
  self.spr = ez.newanim(templates.player.base)
  
  Entity.initialize(self,params)

end


function Player:checkpos(cx,cy)
  for i,v in ipairs(cs.rooms.c.level.tiles) do
    if v.solid or v.wall then
      local tilehitbox = {
        x=v.x*levels.properties.tilesize - 4,
        y=v.y*levels.properties.tilesize - 4,
        width=levels.properties.tilesize*2,
        height=levels.properties.tilesize*2
      }
      
      for _i,_v in ipairs(levels.properties.halfsize)  do
        if v.t == _v then
          tilehitbox.x = tilehitbox.x + 4
          tilehitbox.y = tilehitbox.y + 4
          tilehitbox.width = 4
          tilehitbox.height = 4
          break
        end
      end
      
      if helpers.collide(tilehitbox,{
        x=cx-4,
        y=cy-4,
        width = 8,height = 8}
      ) or cx < 8 or cx > 120 or cy < 8 or cy > 120 then
        --color('green')
        --love.graphics.points(cx,cy)
        --love.graphics.rectangle("line",cx-4,cy-4,8,8)
        --found = true
        --lowest = i
        return true
      end
    end
  end
  return false
end

function Player:update(dt)
  prof.push("player update")
  
  -- lower all cooldowns
  if self.shootcooldown > 0 then
    self.shootcooldown = self.shootcooldown - dt
  end
  
  if self.hitcooldown > 0 then
    self.hitcooldown = self.hitcooldown - dt*1.5
    if self.hitcooldown < 0 then
      self.hitcooldown = 0
    end
  end
  
  if self.blockcooldown > 0 then
    self.blockcooldown = self.blockcooldown - dt
    if self.blockcooldown < 0 then
      self.blockcooldown = 0
      print("blockcooldown over")
    end
  end
  
  if self.speedcooldown > 0 then
    self.speedcooldown = self.speedcooldown - dt
    if self.speedcooldown < 0 then
      self.speedcooldown = 0
      print("speedcooldown over")
    end
  end
  
  local moving = false
  
  
  
  local blockanim = false
  
  if self.canmove then
    
    self.oldx = self.x 
    self.oldy = self.y
    
    self.dx = 0
    self.dy = 0
    
    local speedmult = 1
    
    if maininput:down('block') and self.blockcooldown == 0 then
      if not self.blocking then
        cs:addscore(-50,'blocking')
        self.blocking = true
      end
    else
      if self.blocking then
        self.blocking = false
        self.blockcooldown = self.blockpenalty
        self.speedcooldown = self.speedpenalty
      end
    end
    
    
    
    if self.blocking or self.speedcooldown > 0 then
      speedmult = 0.5
      blockanim = true
      
    end
    
    if self.blocking then
      if self.blockanim < 5 then
        self.blockanim = self.blockanim + dt
      else
        self.blockanim = 5
      end
    elseif self.blockanim > 0 then
      self.blockanim = self.blockanim - dt
    end
    if self.blockanim < 0 then
      self.blockanim = 0
    end
    
    
    if maininput:down('left') and (not maininput:down('right')) then
      self.flip = true
      self.dx = -self.speed * speedmult
      moving = true
      
    end
    if maininput:down('right') and (not maininput:down('left')) then
      self.flip = false
      self.dx = self.speed * speedmult
      moving = true
    end
    
    if maininput:down('up') and (not maininput:down('down')) then
      self.dy = -self.speed * speedmult
      moving = true
    end
    if maininput:down('down') and (not maininput:down('up')) then
      self.dy = self.speed * speedmult
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
      if v.solid or ((not cs.map[cs.croom].cleared) and v.wall) then
        local tilehitbox = {x=v.x*levels.properties.tilesize,y=v.y*levels.properties.tilesize,width=levels.properties.tilesize,height=levels.properties.tilesize}
        if v.t == 2 then
          tilehitbox.x = tilehitbox.x - 4
          tilehitbox.y = tilehitbox.y - 4
          tilehitbox.width = 8
          tilehitbox.height = 8
        end
        if helpers.collide(self.hitbox,tilehitbox) then
          
          if v.t == 2 then
            
            if self.holding == 0 and (maininput:down('shootleft') or maininput:down('shootright') or maininput:down('shootup') or maininput:down('shootdown')) and (not self.blocking) then
              self.holding = 1
              
              
              
              self.gunx = (v.x*levels.properties.tilesize) - self.x
              self.guny = (v.y*levels.properties.tilesize) - (self.y+5)
              
              self.throwhp = v.hp
              
              table.remove(cs.rooms.c.level.tiles,i)
              
              print('picked up box, hp '..self.throwhp)
            end
          end
          
          if helpers.collide(self.oldhitboxx,tilehitbox) and sign(self.hitbox.y - tilehitbox.y) ~= sign(self.cdy)  then yok = false end
          if helpers.collide(self.oldhitboxy,tilehitbox) and sign(self.hitbox.x - tilehitbox.x) ~= sign(self.cdx) then xok = false end
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

    -- guns

    if maininput:down('k1') then
      self.gun = self.gunTypes.pistol
    end
    if maininput:down('k2') then
      self.gun = self.gunTypes.laser
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
    
    if doshoot and self.holding == 0 and (not self.blocking) then
      -- START GUN TYPES
      if self.gun == self.gunTypes.pistol then
        if self.shootcooldown <= 0 then
          self.shootcooldown = 8
          em.init('playerbullet',{x=self.x+(self.gunx*0.85),y=self.y+(self.guny*0.85)-4,dx=self.gunaimx/4,dy=self.gunaimy/4,canv='c'})
          te.play('assets/sfx/player_shoot.ogg','static',{'player_shoot','sfx'},0.7)
        end
      end
      if self.gun == self.gunTypes.laser then
        if self.shootcooldown <= 0 then
          self.shootcooldown = 1
          em.init('playerbullet',{x=self.x+(self.gunx*0.85),y=self.y+(self.guny*0.85)-4,dx=self.gunaimx/4,dy=self.gunaimy/4,canv='c'})
          te.play('assets/sfx/player_shoot.ogg','static',{'player_shoot','sfx'},0.7)
        end
      end
    end
    
    
    prof.push("player holding")
    if self.holding ~= 0 then
      
      local dmove = helpers.rotate(1,helpers.anglepoints(0,0,self.gunx,self.guny),0,0)
      local dx,dy = dmove[1],dmove[2] --dx and dy are from -1 to 1
      
      local lowest = 0
      
      local cx = 0
      local cy = 0
      
      for i=1,32 do
        cx = (self.x) + (dx * i * 4)
        cy = (self.y - 5) + (dy * i * 4)
        love.graphics.points(cx,cy)
        
        
        if self:checkpos(cx,cy) then
          lowest = i - 1
          break
        end
      end
      
      self.throwx = (self.x) + (dx * lowest * 4)
      self.throwy = (self.y - 5) + (dy * lowest * 4)
      
      
      for extra = 0,3 do
        cx = (self.x) + (dx * (lowest+(extra/4)) * 4)
        cy = (self.y - 5) + (dy * (lowest+(extra/4)) * 4)
        if self:checkpos(cx,cy) then
          break
        end
        self.throwx = cx
        self.throwy = cy
      end
      
      
      self.throwx = math.floor(self.throwx/4+0.5)
      self.throwy = math.floor(self.throwy/4+0.5)
      
      self.invalidthrow = helpers.collide(self.hitbox,{
        x=self.throwx*4-4,
        y=self.throwy*4-4,
        width = 8,height = 8})
      
    end
    prof.pop("player holding")
    
    if maininput:pressed('accept') and (not self.blocking) then
      if self.holding == 1 and (not self.invalidthrow) then
        
        local distance = helpers.distance({self.x,self.y-5},{self.throwx*4+5,self.throwy*4+5}) / 200
        local newbox = em.init('thrownbox',{
          x=self.x+self.gunx,
          y=self.y+self.guny-5,
          dx = self.gunx,
          dy = self.guny,
          hp=self.throwhp,
          canv = self.canv
        })
        
        rw:ease(0,distance,'linear',self.throwx*levels.properties.tilesize,newbox,'x')
        rw:ease(0,distance,'linear',self.throwy*levels.properties.tilesize,newbox,'y')
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
      rw:to(self, 30, {x=(0-movedistance),y=64}):oncomplete(function() 
        self.x = 128-movedistance
        self.canmove = true 
        if cs.map[cs.croom].exits.l then
          cs.croom = cs.map[cs.croom].exits.l
          cs:updaterooms()
        end
      end)
      rw:to(cs.cube.r, 30, {y=cuberot,z=0}):ease('outSine')
      te.play('assets/sfx/cube_rotate.ogg','static',{'cube_rotate','sfx'},0.5)
      
    end
    
    if self.x > 120 then
      self.canmove = false
      rw:to(self, 30, {x=128+movedistance,y=64}):oncomplete(function() 
        self.x = movedistance
        self.canmove = true 
        if cs.map[cs.croom].exits.r then
          cs.croom = cs.map[cs.croom].exits.r
          cs:updaterooms()
        end
      end)
      rw:to(cs.cube.r, 30, {y=(0-cuberot),z=0}):ease('outSine')
      te.play('assets/sfx/cube_rotate.ogg','static',{'cube_rotate','sfx'},0.5)
    end
    
    if self.y < 8 then
      self.canmove = false
      rw:to(self, 30, {x=64,y=(0-movedistance)}):oncomplete(function() 
        self.y = 128-movedistance
        self.canmove = true 
        if cs.map[cs.croom].exits.u then
          cs.croom = cs.map[cs.croom].exits.u
          cs:updaterooms()
        end
      end)
      rw:to(cs.cube.r, 30, {y=0,z=(0-cuberot)}):ease('outSine')
      te.play('assets/sfx/cube_rotate.ogg','static',{'cube_rotate','sfx'},0.5)
      
    end
    
    if self.y > 120 then
      self.canmove = false
      rw:to(self, 30, {x=64,y=128+movedistance}):oncomplete(function() 
        self.y = movedistance
        self.canmove = true 
        if cs.map[cs.croom].exits.d then
          cs.croom = cs.map[cs.croom].exits.d
          cs:updaterooms()
        end
      end)
      rw:to(cs.cube.r, 30, {y=0,z=cuberot}):ease('outSine')
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
        if helpers.collide(self.hitbox,v.hitbox) and self.hitcooldown == 0 then
          if not self.blocking then
            self.hitcooldown = 89
            cs:addscore(-200,'gothit')
            te.play('assets/sfx/player_hit.ogg','static',{'player_hit','sfx'},1)
            self.anim = 'hit'
            self.animtimer = 30
            self.nextanim = 'idle'
          else
            --play a "pling" sound?
          end
        end
      end
    end
    
    self.hitbox.height = 6
    self.hitbox.y = self.hitbox.y + 2
    
  end
  
  if self.anim == 'hit' then
    self.frame = 2
  elseif self.anim == 'idle' then
    
    if blockanim then 
      self.frame = 4
    else
      self.frame = 0
    end
    
    if moving then
      self.anim = 'moving'
      
      if blockanim then 
        self.frame = 5
      else
        self.frame = 1
      end
      
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
    
    if blockanim then
      if self.frame == 0 or self.frame == 1 then
        self.frame = self.frame + 4
      end
    else
      if self.frame == 4 or self.frame == 5 then
        self.frame = self.frame - 4
      end
    end
  end
  
  self.animtimer = self.animtimer - dt
  if self.animtimer <= 0 then
    if self.nextanim == 'idle' then
      if blockanim then
        self.frame = 4
      else
        self.frame = 0
      end
      self.anim = 'idle'
    elseif self.nextanim == 'moving' then
      
      if blockanim then
        self.frame = ((self.frame -3)%2)+4
      else
        self.frame = (self.frame + 1)%2
      end
      
      self.animtimer = 10
    end
  end
  
  
  
  prof.pop("player update")
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
      ez.drawframe(self.boxspr,4-self.throwhp,self.x+self.gunx+sx,self.y+self.guny+sy-5,0,1,1,5,5)
      
      if (not self.invalidthrow) or (not self.blocking) then
        love.graphics.draw(sprites.throwcursor,self.throwx*4+sx,self.throwy*4+sy,0,1,1,5,5)
      end
      
      
    end
    
    
    
    
    color()
  end
  
  if math.floor(self.blockanim+0.5) % 2 == 1 then
    love.graphics.setColor(1,58/255,153/255,1)
    love.graphics.circle('line',self.x,self.y-6,11)
    love.graphics.setColor(54/255,46/255,183/255,1)
    love.graphics.circle('line',self.x,self.y-6,10)
  end
end

function Player:draw()
  prof.push("player draw")
  self:drawmain(0,0)
  
  love.graphics.setCanvas(cs.cube.canvas.l)
  self:drawmain(128,0)
  
  love.graphics.setCanvas(cs.cube.canvas.r)
  self:drawmain(-128,0)
  
  love.graphics.setCanvas(cs.cube.canvas.u)
  self:drawmain(0,128)
  
  love.graphics.setCanvas(cs.cube.canvas.d)
  self:drawmain(0,-128)
  prof.pop("player draw")
  
end

return Player