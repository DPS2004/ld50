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
  
  self.isenemy = true
  
  self.hitbox = {x=self.x,y=self.y,width=6,height=6}
  self.oldhitboxx = {x=self.x,y=self.y,width=6,height=6}
  self.oldhitboxy = {x=self.x,y=self.y,width=6,height=6}
  
  Entity.initialize(self,params)
  
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

function Enemy:updatehitbox()
  self.hx = 0
  self.hy = 0
  self.hitbox.x = self.x - 3
  self.hitbox.y = self.y - 3
end

function Enemy:bulletcheck()
  self:updatehitbox()  
  for i,v in ipairs(entities) do
    if v.name == 'playerbullet' then
      if helpers.collide(self.hitbox,v.hitbox) then
        v.delete = true
        self.hp = self.hp - 1
        self.hx = v.dx * 0.5
        self.hy = v.dy * 0.5
        if self.hp > 0 then 
          te.play('assets/sfx/enemy_hit.ogg','static',{'enemy_hit','sfx'},0.9)
        else
          te.play('assets/sfx/enemy_die.ogg','static',{'enemy_hit','sfx'},1)
          cs:addscore(25,'killedenemy')
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
  end
  
  self.hitbox.x = newx - 3
  self.hitbox.y = newy - 3
  
  self.oldhitboxx.x = self.x-3
  self.oldhitboxx.y = newy - 3
  
  self.oldhitboxy.x = newx - 3
  self.oldhitboxy.y = self.y-3
  
  if not params.dontmove then
    local xok = true
    local yok = true
    for i,v in ipairs(cs.rooms.c.level.tiles) do
      if v.t == 0 then
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
  end
end

function Enemy:draw()
  love.graphics.setColor(1,58/255,153/255,1)
  love.graphics.circle('fill',self.x,self.y,self.size)
  color()
  love.graphics.draw(self.spr, self.x - 4, self.y -1.5)
  
end

return Enemy