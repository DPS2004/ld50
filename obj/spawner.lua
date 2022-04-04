Spawner = class('Spawner',Entity)

function Spawner:initialize(params)
  
  self.layer = 11 -- lower layers draw first
  self.uplayer = 0 --lower uplayer updates first
  self.x = 0
  self.y = 0
  self.size = 0
  self.tospawn = 'shooter'
  
  self.isenemy = true
  
  self.enemyy = 0
  self.enemysize = 0
  
  self.hitbox = {x=0,y=0,width=8,height=8}
  
  Entity.initialize(self,params)
  
  rw:ease(0,0.5,'outSine',1,self,'size')
  rw:ease(0,0.5,'outSine',1,self,'enemysize')
  
  rw:ease(0.5,0.5,'outSine',-1,self,'enemyy')
  
  rw:ease(0.75,0.5,'outSine',5,self,'enemysize')
  rw:ease(0.75,0.5,'outSine',0,self,'size')
  rw:func(1.25,function() em.init(self.tospawn,{x=self.x,y=self.y-1,canv=self.canv}) self.delete = true end)
  
  rw:play({bpm=100})
end


function Spawner:update(dt)
  
end

function Spawner:draw()
  love.graphics.setColor(140/255,9/255,153/255,1)
  love.graphics.ellipse('fill',self.x,self.y,4*self.size,3*self.size)
  love.graphics.setColor(1,58/255,153/255,1)
  love.graphics.circle('fill',self.x,self.y+self.enemyy,self.enemysize)
  color()
end

return Spawner