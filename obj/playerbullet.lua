Playerbullet = class('Playerbullet',Entity)

function Playerbullet:initialize(params)
  
  self.layer = 11 -- lower layers draw first
  self.uplayer = 1 --lower uplayer updates first
  self.x = 0
  self.y = 0
  self.dx = 0
  self.dy = 0
  self.name = 'playerbullet'
  
  self.spr = sprites.bullet
  
  self.hitbox = {x=0,y=0,width=4,height=4}
  
  Entity.initialize(self,params)

end


function Playerbullet:update(dt)
  self.x = self.x + self.dx
  self.y = self.y + self.dy
  
  self.hitbox.x = self.x - 2
  self.hitbox.y = self.y - 2
  
  for i,v in ipairs(cs.rooms.c.level.tiles) do
    if v.t == 0 then
      local blockhitbox = {x=v.x*8,y=v.y*8,width=8,height=8}
      if helpers.collide(self.hitbox,blockhitbox) then
        self.delete = true
      end
    end
  end
  if self.x < -8 or self.x > 136 or self.y < -8 or self.y > 136 then
    self.delete = true
  end
end

function Playerbullet:draw()
  color()
  love.graphics.draw(self.spr,self.x,self.y,0,1,1,2,2)
end

return Playerbullet