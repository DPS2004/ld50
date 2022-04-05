local st = Gamestate:new('menu')
require 'lib.perlin'

local credits = love.filesystem.read("data/credits.txt")
local _, credits_linecount = credits:gsub('\n', '\n')
st:setinit(function(self, gameovered, pointsgained, new_highscore)
  if gameovered then
    te.play("assets/music/gameover.ogg","stream","bgm")
  else
    te.playLooping("assets/music/menu.ogg","stream","bgm")
  end
  self.cube = em.init('cube',{x=project.res.cx,y=project.res.y*0.55})
  self.pointsgained = pointsgained
  
  self.start_time = love.timer.getTime()
  self.new_highscore = new_highscore

  self.screen = (gameovered) and 'gameover' or 'title'
  self.screen_rotations = {
    title = {0, 0},
    play =  {-90, 0},
    gameover = {0, -90},
    credits = {90, 0},
    quit = {0, 90},
  }
  
  self.cube_ry = self.screen_rotations[self.screen][1]
  self.cube_rz = self.screen_rotations[self.screen][2]
  self.cube_ry_target = self.screen_rotations[self.screen][1]
  self.cube_rz_target = self.screen_rotations[self.screen][2]

  self.credits_offset = 0
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
  
  love.graphics.print('A - credits', 64 - font:getWidth('A - credits') / 2, 0)
  love.graphics.pop()

  love.graphics.print('S - quit', 64 - font:getWidth('W - quit') / 2, 128 - 12)

    love.graphics.draw(sprites.logo,64,64,0,0.45+math.sin(love.timer.getTime()/2)*0.05,0.5+math.cos(love.timer.getTime()/2)*0.05,109,52)
    
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

  local s = 'PLAY'
  love.graphics.print(s, 64, 32, 0, 2, 2, self.font:getWidth(s) / 2 - 1)

  s = '[press space]'
  love.graphics.print(s, 64, 128 - 48, 0, 1, 1, self.font:getWidth(s) / 2)
  
  local highscore = savedata.highscore or 0
  s = 'highscore: '..highscore
  love.graphics.print(s, 64, 128 - 64, 0, 1, 1, self.font:getWidth(s) / 2)
  love.graphics.pop()
end

function st:drawCredits()
  love.graphics.push('all')
  love.graphics.setCanvas(self.cube.canvas.l)
  love.graphics.clear(0,0,0,1)
  local s = 'W - up'
  love.graphics.print(s, 64 - self.font:getWidth(s) / 2, 1)
  s = 'S - down'
  love.graphics.print(s, 64 - self.font:getWidth(s) / 2, 128 - 12)

  love.graphics.setScissor(0,12, 128, 100)
  s = credits
  love.graphics.printf(s, 14, 12 - self.credits_offset, 100, 'center')
  love.graphics.setScissor()

  love.graphics.push()
  love.graphics.translate(64,64)
  love.graphics.rotate(-math.pi / 2)
  love.graphics.translate(-64,-64)
  s = 'D - main'
  love.graphics.print(s, 64 - self.font:getWidth(s) / 2, 128 - 12)
  love.graphics.pop()

  love.graphics.pop()
end

function st:drawQuit()
  love.graphics.push('all')
  love.graphics.setCanvas(self.cube.canvas.d)
  love.graphics.clear(0,0,0,1)

  love.graphics.print('W - main', 64 - self.font:getWidth('W - main') / 2)
  local s = '[press space]'
  love.graphics.print(s, 64, 128 - 48, 0, 1, 1, self.font:getWidth(s) / 2)
  
  s = 'QUIT?'
  love.graphics.print(s, 64, 32, 0, 2, 2, self.font:getWidth(s) / 2 - 1)
  love.graphics.pop()
end

function st:drawGameover()
  love.graphics.push('all')
  love.graphics.setCanvas(self.cube.canvas.u)
  love.graphics.clear(0,0,0,1)

  local s = 'GAME OVER'
  love.graphics.print(s, 64, 32, 0, 2, 2, self.font:getWidth(s) / 2 - 1)

  s = 'S - main'
  love.graphics.print(s, 64 - self.font:getWidth(s) / 2, 128 - 12)
  
  s = 'you gained '..(self.pointsgained or 'some')..' points'
  love.graphics.print(s, 64, 128 - 48, 0, 1, 1, self.font:getWidth(s) / 2)
  
  s = 'new high score!!'
  if self.new_highscore then
    love.graphics.print(s, 64, 128 - 36, 0, 1, 1, self.font:getWidth(s) / 2)
  end

  love.graphics.pop()
end

function st:update_title()
  if maininput:pressed("right") then
    self.screen = 'play'
    te.play('assets/sfx/cube_rotate.ogg','static',{'cube_rotate','sfx'},0.5)
  elseif maininput:pressed("left") then
    self.screen = 'credits'
    te.play('assets/sfx/cube_rotate.ogg','static',{'cube_rotate','sfx'},0.5)
  elseif maininput:pressed('down') then
    self.screen = 'quit'
    te.play('assets/sfx/cube_rotate.ogg','static',{'cube_rotate','sfx'},0.5)
  end
end

function st:update_credits()
  local max_offset = self.font:getHeight() * credits_linecount - 70 -- why 70? i have no idea
  if maininput:pressed("right") then
    self.screen = 'title'
    te.play('assets/sfx/cube_rotate.ogg','static',{'cube_rotate','sfx'},0.5)
  end
  if maininput:down('up') then
    self.credits_offset = self.credits_offset - 100 * dt / 60
  end
  if maininput:down('down') then
    self.credits_offset = self.credits_offset + 100 * dt / 60
  end

  self.credits_offset = math.min(self.credits_offset, max_offset)
  self.credits_offset = math.max(self.credits_offset, 0)
end

function st:update_gameover()
  if maininput:pressed("down") then
    self.screen = 'title'
    te.stop('bgm',false)
    te.play('assets/sfx/cube_rotate.ogg','static',{'cube_rotate','sfx'},0.5)
    te.playLooping("assets/music/menu.ogg","stream","bgm")
  end
end

function st:update_quit()
  if maininput:pressed("up") then
    self.screen = 'title'
    te.play('assets/sfx/cube_rotate.ogg','static',{'cube_rotate','sfx'},0.5)
  end
  if maininput:pressed("accept") then
    love.event.quit()
  end
end

function st:update_play()
  if maininput:pressed("left") then
    self.screen = 'title'
    te.play('assets/sfx/cube_rotate.ogg','static',{'cube_rotate','sfx'},0.5)
  end
  if maininput:pressed("accept") then
    te.stop('bgm',false)
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
end)

st:setbgdraw(function(self)
  color('black')
  love.graphics.rectangle('fill',0,0,project.res.x,project.res.y)
  color()
  love.graphics.draw(sprites.stadium)
end)

--entities are drawn here
st:setfgdraw(function(self)
  self:drawTitle()
  self:drawPlay()
  self:drawCredits()
  self:drawQuit()
  self:drawGameover()
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