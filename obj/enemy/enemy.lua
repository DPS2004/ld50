Enemy = class('Enemy',Entity)

function Enemy:initialize(params)
  
  self.layer = 11 -- lower layers draw first
  self.uplayer = 2 --lower uplayer updates first
  self.x = 0
  self.y = 0
  self.dx = 0
  self.dy = 0
  self.size = 5
  self.hp = 5
  self.spr = sprites.enemyface
  
  self.hbsize = 3
  
  self.isenemy = true
  
  self.ishit = false
  
  Entity.initialize(self,params)
  
  self.hitbox = {x=self.x-self.hbsize,y=self.y-self.hbsize,width=self.hbsize*2,height=self.hbsize*2}
  self.oldhitboxx = {x=self.x-self.hbsize,y=self.y-self.hbsize,width=self.hbsize*2,height=self.hbsize*2}
  self.oldhitboxy = {x=self.x-self.hbsize,y=self.y-self.hbsize,width=self.hbsize*2,height=self.hbsize*2}
  
end


function Enemy:update(dt)
  self:bulletcheck()
  self:move()
  self:deathcheck()
end

function Enemy:deathcheck()
  if self.hp <= 0 then
    self.delete = true
    em.init('enemypoof',{x=self.x,y=self.y,size=self.size,canv=self.canv})
  end
  
end

function Enemy:shoot()
  local ang = helpers.rotate(1.5,helpers.anglepoints(self.x,self.y,cs.player.x,cs.player.y - 3),0,0)
  em.init('enemybullet',{x=self.x,y=self.y,dx=ang[1],dy=ang[2],canv=self.canv})
  te.play('assets/sfx/enemy_fire.ogg','static',{'enemy_fire','sfx'},0.5)
end

function Enemy:updatehitbox(x,y)
  x = x or self.x
  y = y or self.y
  
  self.hitbox.x = x - self.hbsize
  self.hitbox.y = y - self.hbsize
  self.hitbox.width = self.hbsize*2
  self.hitbox.height = self.hbsize*2
  
  self.oldhitboxx.x = self.x - self.hbsize
  self.oldhitboxx.y = y - self.hbsize
  self.oldhitboxx.width = self.hbsize*2
  self.oldhitboxx.height = self.hbsize*2
  
  self.oldhitboxy.x = x - self.hbsize
  self.oldhitboxy.y = self.y - self.hbsize
  self.oldhitboxy.width = self.hbsize*2
  self.oldhitboxy.height = self.hbsize*2
  
  
  
end

function Enemy:gethit(v, hpminus)
  hpminus = hpminus or 1
  self.hp = self.hp - hpminus
  self.hx = v.dx * 0.5
  self.hy = v.dy * 0.5
  if self.hp > 0 then 
    te.play('assets/sfx/enemy_hit.ogg','static',{'enemy_hit','sfx'},0.9)
    self.ishit = true
  else
    te.play('assets/sfx/enemy_die.ogg','static',{'enemy_hit','sfx'},1)
    cs:addscore(25,'killedenemy')
  end
  
end

function Enemy:bulletcheck()
  
  self.ishit = false
  
  self:updatehitbox()  
  
  for i,v in ipairs(entities) do
    if v.name == 'playerbullet' then
      if helpers.collide(self.hitbox,v.hitbox) then
        v.delete = true
        self:gethit(v)
      end
    end
    if v.name == 'thrownbox' then
      if helpers.collide(self.hitbox,v.hitbox) then
        if v:checkhit(o) then
          self:gethit(v,10)
          v:gethit(self)
        end
      end
    end
  end
  
end

function Enemy:move(dt,params)
  params = params or {}
  params.knockback = params.knockback or 1
  
  self.oldx = self.x 
  self.oldy = self.y
  
  local newx = self.x + self.dx*dt
  local newy = self.y + self.dy*dt
  
  if self.hx then
    if params.movehx and params.movehx.hx and params.movehx.hy then
      params.movehx.hx = params.movehx.hx + self.hx*params.knockback
      params.movehx.hy = params.movehx.hy + self.hy*params.knockback
    else
      newx = newx + self.hx*params.knockback
      newy = newy + self.hy*params.knockback
    end
    
    self.hx = 0
    self.hy = 0
    
  end
  
  self:updatehitbox(newx,newy)
  
  if not params.dontmove then
    local xok = true
    local yok = true
    for i,v in ipairs(cs.rooms.c.level.tiles) do
      if v.solid then
        local blockhitbox = {x=v.x*8,y=v.y*8,width=8,height=8}
        if helpers.collide(self.hitbox,blockhitbox) then
          if params.bounce then
            self.angle = (self.angle + 180)%360
          end
          
          if helpers.collide(self.oldhitboxx,blockhitbox) then yok = false end
          if helpers.collide(self.oldhitboxy,blockhitbox) then xok = false end
        end
      end
    end
    
    if not cs.map[cs.croom].cleared then
      for i,v in ipairs(cs.doortiles) do
        local blockhitbox = {x=v.x*8,y=v.y*8,width=8,height=8}
        if helpers.collide(self.hitbox,blockhitbox) then
          if helpers.collide(self.oldhitboxx,blockhitbox) then yok = false end
          if helpers.collide(self.oldhitboxy,blockhitbox) then xok = false end
        end
      end
    end
    
    if xok then self.x = newx else self.dx = 0 end
    if yok then self.y = newy else self.dy = 0 end
    
    return (not xok) or (not yok)
  end
end

function Enemy:setshader()
  if self.ishit then
    love.graphics.setShader(shaders.whiteout)
  else
    --love.graphics.setShader()
  end
end
function Enemy:endshader()
  if self.ishit then
    love.graphics.setShader()
  end
end

function Enemy:draw()
  self:setshader()
  love.graphics.setColor(1,58/255,153/255,1)
  love.graphics.circle('fill',self.x,self.y,self.size)
  color()
  love.graphics.draw(self.spr, self.x - 4, self.y -1.5)
  self:endshader()
  
end

return Enemy