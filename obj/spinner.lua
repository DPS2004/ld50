Spinner = class('Spinner',Enemy)

function Spinner:initialize(params)
  
  Enemy.initialize(self,params)
  
  self.pulsei = 0
  self.angle = 0
  
  self.extend = 0
  
  self.hp = 20
  
  self.size = 8
  self.layer = 12
  
  self.orbiternum = 4
  
  
  
  self.orbiters = {}
  
  for i=1,self.orbiternum do
    table.insert(self.orbiters,em.init('spinner_orbiter',{x=self.x,y=self.y,parentspinner=self}))
  end
  
  
  rw:ease(0,1,'outExpo',16,self,'extend')
  rw:play()
  
end


function Spinner:update(dt)
  
  self.pulsei = self.pulsei + dt/20
  self.angle = self.angle + dt*3
  
  for i,v in ipairs(self.orbiters) do
    local ang = helpers.rotate(self.extend,(i-0)*(360/self.orbiternum)+ self.angle,self.x,self.y)
    v.x = ang[1]
    v.y = ang[2]
    v:update(dt)
    if v.delete then
      table.remove(self.orbiters,i)
    end
  end
  
  self:bulletcheck()
  self:move(dt)
  self:deathcheck()
  
end


function Spinner:draw()
  love.graphics.push('all')
  for _,c in pairs(cs.cube.canvas) do
    love.graphics.setCanvas(c)
    self:drawt()
  end
  love.graphics.pop()
end

function Spinner:drawt()
  for i,v in ipairs(self.orbiters) do
    v:draw()
  end
  love.graphics.setColor(1,58/255,153/255,1)
  love.graphics.circle('fill',self.x,self.y,self.size+math.sin(self.pulsei))
  color()
  love.graphics.draw(sprites.bossface,self.x-5,self.y-2)
  
  
end

return Spinner