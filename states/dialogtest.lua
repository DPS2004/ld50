local st = Gamestate:new('dialogtest')

st:setinit(function(self)
  
  local diasounds = {}
  for i=0,37 do
    table.insert(diasounds,'assets/sfx/talk/'..i..'.ogg')
  end

  em.init('speechbubble',{x=100,y=100,
    width = 100,height = 100,
    text='woah, &working& ^text^ box',
    showbutton = false,
    sound = diasounds,
    callback = function()  end
  })
end)


st:setupdate(function(self,dt)
  
end)

st:setbgdraw(function(self)
  color('black')
  love.graphics.rectangle('fill',0,0,160,90)
  
  
end)
--entities are drawn here
st:setfgdraw(function(self)
end)

return st