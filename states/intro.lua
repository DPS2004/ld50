local st = Gamestate:new('intro')

st:setinit(function(self)
  
  self.spotlightsiner = 0
  self.spotlighty = -300
  
  self.spotlightcenter = 0
  
  self.topflash = 0
  
  self.bgstate = 0
  
  self.host = em.init('hostdialog', {visible = false})
  
  local diasounds = {}
  for i=0,37 do
    table.insert(diasounds,'assets/sfx/talk/'..i..'.ogg')
  end
  
  --[[
  self.textbox = em.init('textbox',{
    x=0,
    y=99,
    width=352,
    height=99,
    text = "WE HAVE GATHERED THE GREATEST IN THE UNIVERSE",
    color = colors.white,
    --align = "center",
    --callback=self.newcallback,
    length=100,
    sound=diasounds,
    skiprender = true,
    outline = true
  })
  ]]--
  
  local function playcaption(str,x,length)
    self.textbox = em.init('textbox',{
      x=x,
      y=90,
      width=352,
      height=99,
      text = loc.get(str),
      color = colors.white,
      --align = "center",
      --callback=self.newcallback,
      length=length,
      skiprender = true,
      outline = true
    })
  end
  
  
  
  local dialogs = {
    
  }
  
  dialogs[0] = {
    text = loc.get('intro7'),
    width = 150,
    height = 30,
    button = true
  }
  
  dialogs[1] = {
    text = loc.get('intro8'),
    width = 240,
    height = 30,
    button = true
  }
  
  --link together dialog
  dialogs[0].donext = dialogs[1]
  
    
  
  local function queuecaption(beat,str,x,length)
    rw:func(beat,function() playcaption(str,x,length) end)
  end
  
  local function stopcaption(beat)
    rw:func(beat,function()
      self.textbox.delete = true
      self.textbox = nil
    end)
  end
  
  
  queuecaption(0,'intro1',40,-4)
  stopcaption(7)
  
  queuecaption(8,'intro2',70,-4)
  stopcaption(15)
  
  queuecaption(16,'intro3',100,-4)
  stopcaption(23)
  
  rw:ease(24,4,'outExpo',99,self,'spotlighty')
  
  queuecaption(24,'intro4',25,-4)
  stopcaption(31)
  
  queuecaption(32,'intro5',5,-4)
  stopcaption(39)
  
  queuecaption(40,'intro6',30,-4)
  stopcaption(48)
  rw:ease(44,4,'inExpo',1,self,'spotlightcenter')
  
  rw:func(48,function()
    self.topflash = 1 
    self.bgstate = 1
    self.host.visible = true
    
    self.host:say(dialogs[0])
    
  end)
  rw:ease(48,1,'linear',0,self,'topflash')
  
  rw:play({bpm = 110,startbeat=40})
  
  
  
end)


st:setupdate(function(self,dt)
  self.spotlightsiner = (self.spotlightsiner + dt/80)%(math.pi*2)
end)

st:setbgdraw(function(self)
  
  shuv.do_autoscaled(function() 
    color('black')
    love.graphics.rectangle('fill',0,0,352,198)
    if self.bgstate == 0 then
      color('yellow')
      local spotlightx = 176+math.sin(self.spotlightsiner)*130
      local spotlighty = self.spotlighty+math.sin(self.spotlightsiner*2)*50
      love.graphics.circle('fill',
        spotlightx * (1 - self.spotlightcenter) + 176*self.spotlightcenter,
        spotlighty * (1 - self.spotlightcenter) + 99 *self.spotlightcenter,
        60+140*self.spotlightcenter
      )
      --love.graphics.circle('fill',176+math.sin(self.spotlightsiner+math.pi)*130,99+math.sin((self.spotlightsiner)*2+math.pi)*50,60)
      love.graphics.draw(sprites.intromask)
    elseif self.bgstate == 1 then
      color()
      love.graphics.draw(sprites.stage)
    end
  end)
end)
--entities are drawn here
st:setfgdraw(function(self)
  if self.textbox then
    self.textbox:draw()
  end
  
  love.graphics.setColor(1,1,1,self.topflash)
  love.graphics.rectangle('fill',0,0,352,198)
  
end)

return st