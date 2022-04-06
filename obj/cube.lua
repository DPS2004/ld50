
do_move = false
local mm = love.mousemoved
function love.mousemoved(x,y,dx,dy)
  if do_move then g3d.camera.firstPersonLook(dx,dy) end
  if mm then mm(x,y,dx,dy) end
end

Cube = class('Cube',Entity)
function Cube:initialize(params)
  self.cam_unzoom = 1.5
  g3d.camera.fov = math.pi / 3
  g3d.camera.lookAt(0, 5 * self.cam_unzoom, 0, 0, 0, 0)
  self.c_canvas = love.graphics.newCanvas(project.res.x, project.res.y)
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
  
  local vertices = {
  --   coords      uvs    normals    color
    {-1, 1,  1,    1, 0,  0, 0, 0,  1, 1, 1, 1},  -- topright
    {-1, 1, -1,    1, 1,  0, 0, 0,  1, 1, 1, 1},  -- bottomright
    {1,  1, -1,    0, 1,  0, 0, 0,  1, 1, 1, 1}, -- bottomleft
    {1,  1,  1,    0, 0,  0, 0, 0,  1, 1, 1, 1}, -- topleft
  }

  local scale = 1
  self.plane_c = g3d.newModel(vertices, self.canvas.c, {0,0,0}, {0, 0, 0},          {2 * scale,2 * scale,2 * scale})
  self.plane_l = g3d.newModel(vertices, self.canvas.l, {0,0,0}, {0, 0, -math.pi/2}, {2 * scale,2 * scale,2 * scale})
  self.plane_r = g3d.newModel(vertices, self.canvas.r, {0,0,0}, {0, 0, math.pi/2},  {2 * scale,2 * scale,2 * scale})
  self.plane_u = g3d.newModel(vertices, self.canvas.u, {0,0,0}, {math.pi/2,0, 0},   {2 * scale,2 * scale,2 * scale})
  self.plane_d = g3d.newModel(vertices, self.canvas.d, {0,0,0}, {-math.pi/2,0, 0},  {2 * scale,2 * scale,2 * scale})
  
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
  
  self.sx = 1
  self.sy = 1
  
  self.spr = sprites.cobblestone
  
  
  Entity.initialize(self,params)
end


function Cube:project()
	
  for pi, p in ipairs(self.points) do
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

function Cube:updateRotation()
  g3d.camera.updateProjectionMatrix()
  g3d.camera.updateViewMatrix()
  local rx = self.r.x * math.pi / 180
  local ry = self.r.y * math.pi / 180
  local rz = self.r.z * math.pi / 180


  self.plane_r:setRotation(0, -rz,ry + math.pi/2)
  self.plane_l:setRotation(0, rz,ry - math.pi/2)
  self.plane_c:setRotation(rz,0,ry)
  self.plane_u:setRotation(rz + math.pi / 2,0,ry)
  self.plane_d:setRotation(rz - math.pi / 2,0,ry)
end

function Cube:update(dt)
  if do_move then g3d.camera.firstPersonMovement(dt / 100) end

  self.i = self.i + dt
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
  love.graphics.push('all')
  love.graphics.setCanvas({self.c_canvas, depth = true})
  love.graphics.clear()
  love.graphics.setColor(1,1,1,1)

  if true then
    if self.plane_l then self.plane_l:draw() end
    if self.plane_u then self.plane_u:draw() end
    if self.plane_c then self.plane_c:draw() end
    if self.plane_d then self.plane_d:draw() end
    if self.plane_r then self.plane_r:draw() end

    love.graphics.pop()
    love.graphics.setShader(shaders.outline)
    love.graphics.draw(self.c_canvas,self.x,self.y,0,self.sx,self.sy,project.res.cx,project.res.cy)
    love.graphics.setShader()
    do return end
  end

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
  
  love.graphics.pop()
  love.graphics.setShader(shaders.outline)
  love.graphics.draw(self.c_canvas)
  love.graphics.setShader()
end

return Cube