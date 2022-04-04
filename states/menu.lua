local st = Gamestate:new('menu')
require 'lib.perlin'

st:setinit(function(self)
  self.cube = em.init('cube',{x=project.res.cx,y=project.res.y*0.55})

  self.selection = 0
  self.options = {
    { text = loc.get("play"), on_accept = function() cs = bs.load('game') cs:init() end },
    { text = loc.get("credits"), on_accept = function() self.credits_open = true end },
    { text = loc.get("quit"), on_accept = function() love.event.quit() end },
  }
  self.box_width = 0
  self.box_width_target = 0
  
  self.box_x = self:get_option_x(self.selection)
  self.box_x_target = self:get_option_x(self.selection)
  self.box_y = self:get_option_y(self.selection)
  self.box_y_target = self:get_option_y(self.selection)

  self.credits_open = false
  self.credits_x_translate_target = 0
  self.credits_x_translate = 0
  self.start_time = love.timer.getTime()
  self.cube_rz = 0
  self.cube_ry = 0
  self.cube_rz_target = 0
  self.cube_ry_target = 0

  self.screen = 'title'

  self.screen_rotations = {
    title = {0, 0},
    play =  {-90, 0},
    credits = {0, -90},
    quit = {0, 90},
    gameover = {90, 0},
  }
  self.font = love.graphics.getFont()
end)

function st:drawTitle()
  local font = love.graphics.getFont()
  love.graphics.push('all')
  love.graphics.setCanvas(self.cube.canvas.c)
  love.graphics.clear(0, 0, 0, 1)
  love.graphics.setColor(1,1,1,1)

  love.graphics.push()
  love.graphics.translate(64,64)
  love.graphics.rotate(-math.pi / 2)
  love.graphics.translate(-64,-64)
  love.graphics.print('D - play', 64 - font:getWidth('D - play') / 2, 128 - 12)
  love.graphics.pop()

  love.graphics.print('S - quit', 64 - font:getWidth('S - quit') / 2, 128 - 12)
  love.graphics.print('W - credits', 64 - font:getWidth('C - credits') / 2, 2)
  love.graphics.pop()

end

function st:drawPlay()
  love.graphics.push('all')
  love.graphics.setCanvas(self.cube.canvas.r)
  love.graphics.clear(0,0,0,1)
  love.graphics.push()
  love.graphics.translate(64,64)
  love.graphics.rotate(-math.pi / 2)
  love.graphics.translate(-64,-64)
  love.graphics.print('A - main', 64 - self.font:getWidth('A - main') / 2)
  love.graphics.pop()
  love.graphics.print('press space to play\nput the highscore here later \nor something?')
  love.graphics.pop()
end

function st:drawCredits()
  love.graphics.push('all')
  love.graphics.setCanvas(self.cube.canvas.u)
  love.graphics.clear(0,0,0,1)
  -- love.graphics.print('credits go here')
  local s = [[someone who is good at
credits please help me 
write this. my family is
dying]]
  love.graphics.print(s, 64, 0, 0, 1, 1, self.font:getWidth(s) / 2)
   s = 'S - main'
  love.graphics.print(s, 64, 128 - 12, 0, 1, 1, self.font:getWidth(s) / 2)
  love.graphics.pop()
end

function st:drawQuit()
  love.graphics.push('all')
  love.graphics.setCanvas(self.cube.canvas.d)
  love.graphics.clear(0,0,0,1)
  local s = 'W - main'
  love.graphics.print(s, 64, 0, 0, 1, 1, self.font:getWidth(s) / 2)

  s = '[press space]'
  love.graphics.print(s, 64, 128 - 48, 0, 1, 1, self.font:getWidth(s) / 2)
  
  s = 'Quit?'
  love.graphics.print(s, 64, 48, 0, 2, 2, self.font:getWidth(s) / 2 - 1)
  love.graphics.pop()
end

function st:drawGameover()
  love.graphics.push('all')
  love.graphics.setCanvas(self.cube.canvas.l)
  love.graphics.clear(0,0,0,1)
  love.graphics.print('gameover goes here')
  love.graphics.pop()
end

function st:update_title()
  if maininput:pressed("right") then
    self.screen = 'play'
  elseif maininput:pressed("down") then
    self.screen = 'quit'
  elseif maininput:pressed('up') then
    self.screen = 'credits'
  end
end

function st:update_credits()
  if maininput:pressed("down") then
    self.screen = 'title'
  end
end

function st:update_gameover()
  if maininput:pressed("right") then
    self.screen = 'title'
  end
end

function st:update_quit()
  if maininput:pressed("up") then
    self.screen = 'title'
  end
  if maininput:pressed("accept") then
    love.event.quit()
  end
end

function st:update_play()
  if maininput:pressed("left") then
    self.screen = 'title'
  end
  if maininput:pressed("accept") then
    cs = bs.load('game') 
    self.cube.delete = true
    cs:init()
  end
end


st:setupdate(function(self,dt)
  self.font = love.graphics.getFont()
  local rotations = self.screen_rotations[self.screen]
  local screen_update = self['update_'..self.screen]
  if screen_update then screen_update(self) end

  self.cube_ry_target = rotations[1]
  self.cube_rz_target = rotations[2]
  local speed = 0.15
  -- local amplitude = 15
  local amplitude = 10
  local time = (love.timer.getTime() - self.start_time) * speed
  local noise = perlin:noise(time, 0, time)
  local noise2 = perlin:noise(time + 10.5, time, 100)
  local noise3 = perlin:noise(200, time, time +100)
  self.cube.r.y = noise * amplitude + self.cube_ry
  self.cube.r.z = noise2 * amplitude + self.cube_rz
  self.cube.r.x = noise2 * amplitude
  self.cube:updateRotation()
  local function lerp(a, b, t)
    local h = helpers.lerp(a, b, t)
    return (math.abs(a - b) > 0.3) and h or b
  end 

  self.cube_ry = lerp(self.cube_ry, self.cube_ry_target, 0.1)
  self.cube_rz = lerp(self.cube_rz, self.cube_rz_target, 0.1)

  self.credits_x_translate = lerp(self.credits_x_translate, self.credits_x_translate_target, 0.15)
end)

st:setbgdraw(function(self)
  color('black')
  love.graphics.rectangle('fill',0,0,project.res.x,project.res.y)
  color()
end)

--entities are drawn here
st:setfgdraw(function(self)
  self:drawTitle()
  self:drawPlay()
  self:drawCredits()
  self:drawQuit()
  self:drawGameover()
  do return end
  love.graphics.push()
  color('red')
  local font = love.graphics.getFont()
  love.graphics.translate(self.credits_x_translate, 0)
  love.graphics.push()
    love.graphics.translate(project.res.x, 0)
    local string = [[
game by:
dps2004
deadlysprinklez
bunner
pipes
]]
    love.graphics.print(string, project.res.x / 2 - font:getWidth(string) / 2, 64)
  love.graphics.pop()
  love.graphics.translate(project.res.x / 2, project.res.y - 80)

  -- love.graphics.print(loc.get('helloworld'),10,10)

  local width = 0
  local height = font:getHeight() + 1
  for _, v in ipairs(self.options) do
    width = math.max(width, font:getWidth(v.text))
  end

  local x = -width / 2
  
  local selected = self.options[self.selection + 1]
  self.box_y_target = self:get_option_y(self.selection)
  self.box_width_target = font:getWidth(selected.text)
  self.box_x_target = self:get_option_x(self.selection)
  love.graphics.setLineWidth(0.5)
  love.graphics.rectangle('line', self.box_x - 2, self.box_y, self.box_width + 4, height - 1)
  for i, v in ipairs(self.options) do
    love.graphics.print(v.text, self:get_option_x(i - 1), self:get_option_y(i - 1))
  end
  love.graphics.pop()
end)

function st:get_option_x(index)
  local font = love.graphics.getFont()
  return -font:getWidth(self.options[index + 1].text) / 2
end

function st:get_option_y(index)
  local font = love.graphics.getFont()
  local height = font:getHeight() + 1
  return (index) * height
end

return st