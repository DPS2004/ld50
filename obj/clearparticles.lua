Clearparticles = class('Clearparticles',Entity)

function Clearparticles:initialize(params)
  
  self.layer = -9 -- lower layers draw first
  self.uplayer = 0 --lower uplayer updates first
  
  
  Entity.initialize(self,params)
  
  self.particles = {}
  
  for i = 0,100 do
    table.insert(self.particles,{x=math.random(4,124),y=math.random(4,124),dx=math.random(-5,5)/10,dy=math.random(-5,5)/10,color = math.random(0,1),size = 2+(math.random(0,25)/100)})
  end

end


function Clearparticles:update(dt)
  prof.push("clearparticles update")
  for i,v in ipairs(self.particles) do
    v.size = v.size - (dt / 30)
    v.x = v.x + v.dx * v.size * dt
    v.y = v.y + v.dy * v.size * dt
    if v.size <= 0 then
      table.remove(self.particles,i)
    end
    
  end
  if #self.particles == 0 then
    self.delete = true
  end
  prof.pop("clearparticles update")
end

function Clearparticles:draw()
  prof.push("clearparticles draw")
  for i,v in ipairs(self.particles) do
    if v.color == 0 then
      love.graphics.setColor(0,69/255,119/255)
    else
      love.graphics.setColor(0,44/255,76/255)
    end
    love.graphics.circle('fill',v.x,v.y,v.size*2)
  end
  prof.pop("clearparticles draw")
  color()
end

return Clearparticles