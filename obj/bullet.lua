Bullet = class('Bullet',Entity)

function Bullet:initialize(params)
  
  self.layer = 11 -- lower layers draw first
  self.uplayer = 1 --lower uplayer updates first
  self.x = 0
  self.y = 0
  self.dx = 0
  self.dy = 0
  self.name = 'bullet'
  
  self.size = 2
  self.hbsize = 2
  
  self.spr = sprites.bullet
  
  
  Entity.initialize(self,params)
  
  
  self.hitbox = {x=self.x - self.hbsize,y=self.y-self.hbsize,width=self.hbsize*2,height=self.hbsize*2}

end

function Bullet:move(dt)
  self.x = self.x + self.dx*dt
  self.y = self.y + self.dy*dt
  
  self.hitbox.x = self.x - self.hbsize
  self.hitbox.y = self.y - self.hbsize
end

function Bullet:checkwalls()
  for i,v in ipairs(cs.rooms.c.level.tiles) do
    if v.solid or ((not cs.map[cs.croom].cleared) and v.wall) and (not v.bulletpass) then
      local blockhitbox = {x=v.x*levels.properties.tilesize,y=v.y*levels.properties.tilesize,width=levels.properties.tilesize,height=levels.properties.tilesize}
      if helpers.collide(self.hitbox,blockhitbox) then
        self.delete = true
      end
    end
  end
  if self.x < -8 or self.x > 136 or self.y < -8 or self.y > 136 then
    self.delete = true
  end
end

function Bullet:update(dt)
  self:move(dt)
  self:checkwalls()
end




function Bullet:draw()
  color()
  if self.size == 2 then
    love.graphics.draw(self.spr,self.x,self.y,0,1,1,3,3)
  end
end

return Bullet