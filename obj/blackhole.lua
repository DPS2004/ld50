require 'lib.perlin'

BlackHole = class('BlackHole', Entity)

function BlackHole:initialize(params)
    self.tc_size = 128
    self.prev_swirl = love.graphics.newCanvas(self.tc_size, self.tc_size)
    self.current_swirl = love.graphics.newCanvas(self.tc_size, self.tc_size)
    self.x = 0
    self.y = 0
    self.scale = 0

    self.angle = 0
    self.time = 0
    self.particles = {}
    self.particle_spawn_delay = 0.05
    self.particle_spawn_timer = self.particle_spawn_delay
    self.particle_spawn_distance = 40

    self.level_transitioning = false;

    self.colors = {
        { 0.235, 0, 0.306 },
        { 0.169, 0.306, 0.647 },
        { 0.361, 0.804, 0.816 },
    }
    self.pull_force = 0
    Entity.initialize(self, params)
end

function BlackHole:update(dt)
    self.scale = helpers.lerp(self.scale, 1, 0.1)
    self.time = self.time + dt
    self.angle = self.angle - math.pi / 3 * dt / 60
    
    self.pull_force = self.pull_force + 1 * dt / 400

    local player = cs.player
    local dx = self.x - player.x
    local dy = self.y - player.y + 8
    local magnitude = helpers.distance({0, 0}, {dx, dy})

    local mx = dx / magnitude * self.pull_force
    local my = dy / magnitude * self.pull_force

    if math.abs(mx) > math.abs(dx) then mx = dx end
    if math.abs(my) > math.abs(dy) then my = dy end

    player.x = player.x + mx
    player.y = player.y + my

    if math.abs(dx) + math.abs(dy) < 5 and not self.level_transitioning then
        self.level_transitioning = true
        self.pull_force = 2
        rw:ease(0, 1, 'inSine', 0, cs.cube, 'sx')
        rw:func(1, function()
            cs.map = cs:levelgen(cs.level)

            cs.croom = 1
            cs.player.x = 64
            cs.player.y = 64
            cs:updaterooms()
            cs:playmusic(0)
            self.delete = true
        end)
        rw:ease(1, 1, 'inSine', 1, cs.cube, 'sx')
        rw:play({ bpm = 120 })
    end

    self.particle_spawn_timer = self.particle_spawn_timer - dt / 60
    if self.particle_spawn_timer < 0 then
        self.particle_spawn_timer = self.particle_spawn_delay
        local angle = love.math.random() * math.pi * 2
        local distance = self.particle_spawn_distance
        self.particles[#self.particles+1] = {angle = angle, distance = distance}        
    end

    for i = #self.particles, 1, -1 do
        local p = self.particles[i]
        p.distance = p.distance - 0.5
        if p.distance <= 0 then
            table.remove(self.particles, i)
        end
    end
end


function BlackHole:drawParticles(x_offset, y_offset)
    love.graphics.push('all')
    love.graphics.translate(64, 64)
    
    love.graphics.setColor(self.colors[3])
    for _, v in ipairs(self.particles) do
        local shift_amount = helpers.map(v.distance, 0, self.particle_spawn_distance, 3, 0)
        local x = x_offset * shift_amount
        local y = y_offset * shift_amount
        local r = helpers.map(v.distance, self.particle_spawn_distance, self.particle_spawn_distance - 10, 0, 2)
        r = helpers.clamp(r, 0, 2)

        love.graphics.push()
        love.graphics.translate(x, y)
        love.graphics.rotate(v.angle + self.angle * 1.3)    
        
        love.graphics.circle('fill', 0, v.distance, r)
        love.graphics.pop()
    end

    love.graphics.translate(-64, -64)
    love.graphics.pop()
end


local function drawSlice(x, y, angle, radius, width, distance, angle_offset, invert)
    love.graphics.push()
    love.graphics.translate(x, y)
    if invert then
        love.graphics.scale(-1, 1)
    end
    love.graphics.rotate(angle)
    love.graphics.translate(0, distance)
    love.graphics.rotate(-angle + angle_offset)

    love.graphics.push()
        love.graphics.rotate(angle + width)
        love.graphics.translate(0, radius)        
        love.graphics.stencil(function()
            love.graphics.circle('fill', 0, 0, radius)
        end, 'increment')
    love.graphics.pop()
        
        
    love.graphics.push() 
        love.graphics.setStencilTest('equal', 0)
        love.graphics.rotate(angle)
        love.graphics.translate(0, radius)
        -- color('red')
        love.graphics.circle('fill', 0, 0, radius)
        love.graphics.pop()
    love.graphics.pop()
    
    love.graphics.setStencilTest()
end

function BlackHole:drawLayer(x, y, layercolor, angle, inner_r, slice_r, slices, slice_inset, invert, overall_scale)
    color('white')

    love.graphics.push('all')
        love.graphics.setCanvas({ self.current_swirl, stencil = true })
        love.graphics.clear()
        love.graphics.translate(self.current_swirl:getWidth() / 2, self.current_swirl:getHeight() / 2)
        love.graphics.scale(overall_scale, overall_scale)
        love.graphics.translate(-self.current_swirl:getWidth() / 2, -self.current_swirl:getHeight() / 2)
        
        -- draw layer to current_swirl
        for i = 0, slices - 1 do
            drawSlice(x, y, (i / slices) * math.pi * 2 + angle, slice_r, math.pi / 12, inner_r - slice_inset, math.pi / 2 * 0.6, invert)
        end
        love.graphics.circle('fill', x, y, inner_r)

        -- mask the layer using the previous layer
        love.graphics.push('all')
            love.graphics.setBlendMode('multiply', 'premultiplied')
            love.graphics.draw(self.prev_swirl)
        love.graphics.pop()

        -- save current layer to the previous one
        love.graphics.setCanvas({ self.prev_swirl, stencil = true })
        love.graphics.clear()
        love.graphics.draw(self.current_swirl)
    love.graphics.pop()

    -- draw layer to screen
    love.graphics.setColor(layercolor)
    love.graphics.draw(self.current_swirl)
end

function BlackHole:drawt(canvas, ry_offset, rz_offset)
    love.graphics.setCanvas(canvas)
    
    local overall_scale = self.scale
    local slice_r = 12
    local inner_r = 25
    local slices = 10

    local inset = 18

    local ry = cs.cube.r.y + (ry_offset or 0)
    local rz = cs.cube.r.z + (rz_offset or 0)
    -- print(ry)

    local shallowness = 6
    local x_offset = -ry / shallowness 
    local y_offset = rz / shallowness 
    
    -- swirl 1
    self.prev_swirl:renderTo(function() love.graphics.clear(1,1,1,1) end)
    self:drawLayer(self.x, self.y, self.colors[1], self.angle, inner_r, slice_r, slices, inset, false, overall_scale)
    
    -- swirl 2
    slices = slices - 1
    slice_r = 9
    inner_r = 18
    inset = inset - 5
    self:drawLayer(self.x + x_offset, self.y + y_offset, self.colors[2], self.angle, inner_r, slice_r, slices, inset, true, overall_scale)
    
    
    -- swirl 3
    slices = slices - 1
    slice_r = 8
    inner_r = 12
    self:drawLayer(self.x + x_offset * 2, self.y + y_offset * 2, self.colors[3], self.angle, inner_r, slice_r, slices, inset, false, overall_scale)
    
    -- inner circle
    color('white')
    slices = 0
    inner_r = 10
    self:drawLayer(self.x + x_offset * 3, self.y + y_offset * 3, self.colors[1], self.angle, inner_r, slice_r, slices, inset, false,overall_scale)

    color('white')
    self:drawParticles(x_offset, y_offset)
end

function BlackHole:draw()
    love.graphics.push('all')
    local c = cs.cube.canvas
    self:drawt(c.c)
    self:drawt(c.d, 0, -90)
    self:drawt(c.u, 0, 90)
    self:drawt(c.l, -90, 0)
    self:drawt(c.r, 90, 0)
    love.graphics.pop()
end

return BlackHole
