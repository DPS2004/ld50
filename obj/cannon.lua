Cannon = class('Cannon',Enemy)

function Cannon:initialize(params)
  
  Enemy.initialize(self,params)
  self.shoottimer = math.random(80,120)
  self.shotsleft = 2
end


function Cannon:update(dt)
  if self.shoottimer > 0 then
    self.shoottimer = self.shoottimer - dt
  else
    self.shoottimer = math.random(100,150)
    self.shotsleft = 2
  end
  
  local shootstate = math.floor(self.shoottimer / 8)
  
  if shootstate > 5 then
    self.angle = helpers.anglepoints(self.x,self.y,cs.player.x,cs.player.y - 3)
  end
  
  if self.shotsleft >= shootstate then
    self.shotsleft = self.shotsleft - 1
    local ang = helpers.rotate(2,self.angle,0,0)
    em.init('enemybullet',{x=self.x,y=self.y,dx=ang[1],dy=ang[2],canv=self.canv})
    te.play('assets/sfx/enemy_fire.ogg','static',{'enemy_fire','sfx'},0.5)
  end
  
  self:bulletcheck()
  self:move(dt)
  self:deathcheck()
end

function Cannon:draw()
  love.graphics.draw(sprites.cannon,self.x,self.y,math.rad(self.angle),1,1,5,7)
  Enemy.draw(self)
  
end

return Cannon