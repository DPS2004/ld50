local st = Gamestate:new('menu')

st:setinit(function(self)
  self.selection = 0
  self.options = {
    { text = loc.get("play"), on_accept = function() cs = bs.load('game') cs:init() end },
    { text = loc.get("credits"), on_accept = function() print("made by me") end },
    { text = loc.get("quit"), on_accept = function() love.event.quit() end },
  }
  self.box_width = 0
  self.box_width_target = 0
  
  self.box_x = self:get_option_x(self.selection)
  self.box_x_target = self:get_option_x(self.selection)
  self.box_y = self:get_option_y(self.selection)
  self.box_y_target = self:get_option_y(self.selection)
end)


st:setupdate(function(self,dt)
  local function lerp(a, b, t)
    local h = helpers.lerp(a, b, t)
    return (math.abs(a - b) > 0.3) and h or b
  end
  self.box_width = lerp(self.box_width, self.box_width_target, 0.15)
  self.box_y = lerp(self.box_y, self.box_y_target, 0.15)
  self.box_x = lerp(self.box_x, self.box_x_target, 0.15)


  if maininput:pressed('down') then
    self.selection = (self.selection + 1) % #self.options
  end
  if maininput:pressed('up') then
    self.selection = self.selection - 1
    if self.selection < 0 then 
      self.selection = self.selection + #self.options 
    end
  end
  if maininput:pressed('accept') then
    self.options[self.selection + 1].on_accept()
  end
end)

st:setbgdraw(function(self)
  color('black')
  love.graphics.rectangle('fill',0,0,project.res.x,project.res.y)

end)

--entities are drawn here
st:setfgdraw(function(self)   
  love.graphics.push()
  love.graphics.translate(project.res.x / 2, project.res.y - 80)
  love.graphics.scale(2, 2)
  color('red')
  -- love.graphics.print(loc.get('helloworld'),10,10)

  local font = love.graphics.getFont()
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
  love.graphics.rectangle('line', self.box_x - 2, self.box_y, self.box_width + 4, height )
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