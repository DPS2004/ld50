Cube = class('Cube',Entity)

function Cube:initialize(params)
  
  self.layer = 100 -- lower layers draw first
  self.uplayer = 0 --lower uplayer updates first
  self.x = 0
  self.y = 0
  self.i = 0
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
  self.faces.l = {8,4,2,6}
  self.faces.r = {3,7,5,1}
  self.faces.u = {8,7,3,4}
  self.faces.d = {2,1,5,6}
  
  
  self.canvas = {}
  
  self.canvas.c = love.graphics.newCanvas(128,128)
  self.canvas.l = love.graphics.newCanvas(128,128)
  self.canvas.r = love.graphics.newCanvas(128,128)
  self.canvas.u = love.graphics.newCanvas(128,128)
  self.canvas.d = love.graphics.newCanvas(128,128)
  
    
  
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
  local amp = 90
  self.i = self.i + dt
  --self.r.x = self.r.x + dt
  --self.r.y = math.sin(self.i/60)*amp
  --self.r.z = math.cos(self.i/60)*amp
  --
end

function Cube:drawface(k)
  local p = self.points
  local v = self.faces[k]
  persp.quad(self.canvas[k],
    {p[v[1]].px+self.x,p[v[1]].py+self.y},
    {p[v[2]].px+self.x,p[v[2]].py+self.y},
    {p[v[3]].px+self.x,p[v[3]].py+self.y},
    {p[v[4]].px+self.x,p[v[4]].py+self.y}
  )
end

function Cube:draw()
  self:project()
  color('white')
  local drawlr = function()
    if self.r.y > 0 then
      self:drawface('l')
    else
      self:drawface('r')
    end
  end
  
  local drawdu = function()
    if self.r.z > 0 then
      self:drawface('d')
    else
      self:drawface('u')
    end
  end
  
  local drawlrdu = function()
    if math.abs(self.r.z) > math.abs(self.r.y) then
      drawlr()
      drawdu()
    else
      drawdu()
      drawlr()
    end
  end
  

  drawlrdu()
  self:drawface('c')
  

  
  
  --[[
  for pi,p in ipairs(self.points) do
    love.graphics.setColor(1,p.pd,p.pd,1)
    love.graphics.circle('fill',p.px+self.x,p.py+self.y,0.5+p.pd*4)
  end
  --]]
  
  
end

return Cube