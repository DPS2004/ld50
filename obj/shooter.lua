Shooter = class('Shooter',Enemy)

function Shooter:initialize(params)
  
  Enemy.initialize(self,params)
  self.shoottimer = math.random(30,60)
end


function Shooter:update(dt)
  if self.shoottimer > 0 then
    self.shoottimer = self.shoottimer - dt
  else
    self.shoottimer = math.random(50,80)
    local ang = helpers.rotate(1.5,helpers.anglepoints(self.x,self.y,cs.player.x,cs.player.y - 3),0,0)
    em.init('enemybullet',{x=self.x,y=self.y,dx=ang[1],dy=ang[2],canv=self.canv})
  end
  self:bulletcheck()
  self:move()
  self:deathcheck()
end

function Shooter:draw()
  Enemy.draw(self)
  
end

return Shooter