EnemyPoof = class('EnemyPoof',Entity)

function EnemyPoof:initialize(params)
  
  self.layer = 3 -- lower layers draw first
  self.uplayer = 3 --lower uplayer updates first
  self.x = 0
  self.y = 0
  
  self.poofease = 0
  
  self.size = 5
  
  Entity.initialize(self,params)
  
  rw:ease(0,1,'outExpo',1,self,'poofease')
  rw:func(1,function() self.delete = true end)
  rw:play()
  
  

end


function EnemyPoof:update(dt)
end

function EnemyPoof:draw()
  prof.push("enemypoof draw")
  love.graphics.setColor(1,58/255,153/255,1)
  
  love.graphics.circle('fill',self.x-self.poofease*4,self.y,self.size*(1-self.poofease))
  love.graphics.circle('fill',self.x+self.poofease*4,self.y,self.size*(1-self.poofease))
  love.graphics.circle('fill',self.x,self.y-self.poofease*4,self.size*(1-self.poofease))
  love.graphics.circle('fill',self.x,self.y+self.poofease*4,self.size*(1-self.poofease))
  prof.pop("enemypoof draw")
end

return EnemyPoof