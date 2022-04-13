Speechbubble = class('Speechbubble',Entity)

function Speechbubble:initialize(params)
  
  self.layer = 110   --lower layer draws first
  self.uplayer = 1  --lower uplayer updates first
  
  self.x = 80
  self.y = 45
  self.width = 40
  self.height = 40
  self.border = 1
  self.length = 200
  self.showbutton = true
  self.text = '^hello^, world&!&'
  
  self.autostart = true
  
  self.taildir = "right"
  self.tailwidth = 5
  self.tailheight=7
  
  self.color = colors.white
  self.outline = true
  self.tailspr = sprites.speechtail
  
  Entity.initialize(self,params)
  self.pressbutton = ez.newanim(templates.pressbutton)
  
  self.tailoffset = self.tailoffset or self.height/2
  
  self.doshowbutton = false
  
  if self.taildir == "up" then
    self.tailr = 0
    self.xbox = 0-self.tailoffset
    self.ybox = 0-self.height-self.tailheight
  elseif self.taildir == "down" then
    self.tailr = 180
    self.xbox = 0-self.tailoffset
    self.ybox = self.tailheight
  elseif self.taildir == "left" then
    self.tailr = 270
    self.xbox = 0-self.width - self.tailheight
    self.ybox = 0-self.tailoffset
  else
    self.tailr = 90
    self.xbox = self.tailheight
    self.ybox = 0-self.tailoffset
  end
  
  self.buttonpressed = false
  self.waitforbutton = false
  
  self.sound = self.sound or 'assets/sfx/text.ogg'
  
  self.newcallback = function()
    if self.showbutton then
      self.doshowbutton = true
    end
    self.waitforbutton = true
    if self.textcallback then self.textcallback() end
  end
  
  
  if self.autostart then
    self:start()
  end
  
  
  
end
function Speechbubble:start()
  self.textbox = em.init('textbox',{
    x=self.xbox+self.x+self.border,
    y=self.ybox+self.y+1,
    width=self.width-self.border*2,
    height=self.height,text=self.text,
    callback=self.newcallback,
    length=self.length,
    sound=self.sound,
    skiprender = true
  })
end

function Speechbubble:update(dt)
  if self.doshowbutton then
    ez.update(self.pressbutton)
  end
  if self.waitforbutton then
    if maininput:pressed("accept") then
      self.waitforbutton = false
      if self.buttoncallback then self.buttoncallback(self) end
    end
  end
end

function Speechbubble:cleanup()
  self.textbox.delete = true
  self.delete = true
end

function Speechbubble:draw()
  love.graphics.setColor(self.color)
  
  local df = function(x,y)
    love.graphics.draw(self.tailspr,self.x+x,self.y+y,math.rad(self.tailr),self.tailwidth/5,self.tailheight/7,math.floor(self.tailwidth/2),self.tailheight)
    --note: somehow make this have rounded edges
    love.graphics.rectangle('fill',self.x+x + self.xbox,self.y+y + self.ybox,self.width,self.height)
  end
  if self.outline then
    helpers.drawbordered(df,'black',true)
  else
    df(0,0)
  end
  if self.textbox then
    self.textbox:draw(self.x+self.xbox+self.border,self.y+self.ybox+1)
  end
  color()
  if self.doshowbutton then
    ez.draw(self.pressbutton, self.x + self.xbox + self.width - 9,self.y + self.ybox +self.height-9)
  end
  

end

return Speechbubble