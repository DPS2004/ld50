local shaders = {}

shaders.outline = love.graphics.newShader('assets/shaders/outline.glsl')
shaders.walls = love.graphics.newShader('assets/shaders/walls.glsl')
shaders.whiteout = love.graphics.newShader('assets/shaders/whiteout.glsl')

return shaders