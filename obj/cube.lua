Cube = class('Cube',Entity)

function Cube:initialize(params)
  
  self.layer = 100 -- lower layers draw first
  self.uplayer = 0 --lower uplayer updates first
  self.x = 0
  self.y = 0
  self.fov = 150
  self.r = {x=0,y=0,z=0}
  self.scale = {x=1,y=1,z=1,g=48}
  
  local defaultvert = {
    {0,0,0,0},
    {0,0,1,0},
    {0,0,1,1},
    {0,0,0,1},
  }
  self.faces = {}
  
  self.faces.c = {4,3,1,2}
  
  
  self.canvas = {}
  
  self.canvas.c = love.graphics.newCanvas(128,128)
  
  self.mesh = {}
  
  self.mesh.c = love.graphics.newMesh(defaultvert,'fan')
  
    
  
  self.points = {
    {x=1,y=1,z=1},
    {x=-1,y=1,z=1},
    {x=1,y=-1,z=1},
    {x=-1,y=-1,z=1},

    {x=1,y=1,z=-1},
    {x=-1,y=1,z=-1},
    {x=1,y=-1,z=-1},
    {x=-1,y=-1,z=-1},

    {x=0,y=0,z=0},
	}
  

  
  
  self.spr = sprites.cobblestone
  
  Entity.initialize(self,params)

end


function Cube:project()
	
  for pi,p in ipairs(self.points) do
    local cosx = math.cos(self.r.x*(math.pi/180))
    local sinx = math.sin(self.r.x*(math.pi/180))
    
    local cosy = math.cos(self.r.y*(math.pi/180))
    local siny = math.sin(self.r.y*(math.pi/180))
    
    local cosz = math.cos(self.r.z*(math.pi/180))
    local sinz = math.sin(self.r.z*(math.pi/180))
    
    local xx = cosx * cosy
    local xy = cosx * siny * sinz - sinx * cosz
    local xz = cosx * siny * cosz + sinx * sinz
    
    local yx = sinx * cosy
    local yy = sinx * siny * sinz + cosx * cosz
    local yz = sinx * siny * cosz - cosx * sinz
    
    local zx = 0 - siny
    local zy = cosy * sinz
    local zz = cosy * cosz
    
    local px = xx*p.x + xy*p.y + xz*p.z
    local py = yx*p.x + yy*p.y + yz*p.z
    local pz = zx*p.x + zy*p.y + zz*p.z
    
    px = px * self.scale.x * self.scale.g
    py = py * self.scale.y * self.scale.g
    pz = pz * self.scale.z * self.scale.g
    
    
    p.px = px * (1+ (pz / self.fov))
    p.py = py * (1+ (pz / self.fov))
    p.pd = pz/200 + 0.5
  end
	
	
end

function Cube:update(dt)
  --self.r.x = self.r.x + dt
  self.r.y = self.r.y + dt
  --self.r.z = self.r.y + dt
  --
end

function Cube:draw()
  self:project()
  color('white')
  local p = self.points
  for k,v in pairs(self.faces) do
    persp.quad(self.canvas[k],
      {p[v[1]].px+self.x,p[v[1]].py+self.y},
      {p[v[2]].px+self.x,p[v[2]].py+self.y},
      {p[v[3]].px+self.x,p[v[3]].py+self.y},
      {p[v[4]].px+self.x,p[v[4]].py+self.y}
    )
--    self.mesh[k]:setVertex(1,p[v[1]].px+self.x,p[v[1]].py+self.y,0,0)
--    self.mesh[k]:setVertex(2,(p[v[1]].px + p[v[2]].px)*0.5 +self.x,(p[v[1]].py + p[v[2]].py)*0.5 +self.y,0.5,0)

--    self.mesh[k]:setVertex(3,p[v[2]].px+self.x,p[v[2]].py+self.y,1,0)
--    self.mesh[k]:setVertex(4,(p[v[2]].px + p[v[3]].px)*0.5 +self.x,(p[v[2]].py + p[v[3]].py)*0.5 +self.y,1,0.5)
    
--    self.mesh[k]:setVertex(5,p[v[3]].px+self.x,p[v[3]].py+self.y,1,1)
--    self.mesh[k]:setVertex(6,(p[v[3]].px + p[v[4]].px)*0.5 +self.x,(p[v[3]].py + p[v[4]].py)*0.5 +self.y,0.5,1)
    
--    self.mesh[k]:setVertex(7,p[v[4]].px+self.x,p[v[4]].py+self.y,0,1)
--    self.mesh[k]:setVertex(8,(p[v[4]].px + p[v[1]].px)*0.5 +self.x,(p[v[4]].py + p[v[1]].py)*0.5 +self.y,0,0.5)
    
--    self.mesh[k]:setTexture(self.canvas[k])
--    love.graphics.draw(self.mesh[k])
    
  end
  
  --[[
  for pi,p in ipairs(self.points) do
    love.graphics.setColor(1,p.pd,p.pd,1)
    love.graphics.circle('fill',p.px+self.x,p.py+self.y,0.5+p.pd*4)
  end
  --]]
  
  
end

return Cube