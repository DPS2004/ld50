Cube = class('Cube',Entity)

function Cube:initialize(params)
  
  self.layer = 0 -- lower layers draw first
  self.uplayer = 0 --lower uplayer updates first
  self.x = 0
  self.y = 0
  self.fov = 150
  self.r = {x=0,y=0,z=0}
  self.scale = {x=1,y=1,z=1,g=48}
  
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
  
  self.faces = {
    {1,2,4,3},
    {5,6,8,7},
    {1,3,7,5},
    {2,4,8,6},
    {1,2,6,5},
    {3,4,8,7}
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
  self.r.x = self.r.x + dt
  self.r.y = self.r.y + dt
  self.r.z = self.r.y + dt
  self:project()
end

function Cube:draw()
  color('white')
  
  for pi,p in ipairs(self.points) do
    love.graphics.setColor(1,p.pd,p.pd,1)
    love.graphics.circle('fill',p.px+self.x,p.py+self.y,0.5+p.pd*4)
  end
  
end

return Cube