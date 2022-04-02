local st = Gamestate:new('cubetest')

st:setinit(function(self)
  self.cube = em.init('cube',{x=project.res.cx,y=project.res.cy})
  em.init('floortile',{canv='c'})
  em.init('floortile',{canv='l'})
  em.init('floortile',{canv='r'})
  em.init('floortile',{canv='u'})
  em.init('floortile',{canv='d'})
end)


st:setupdate(function(self,dt)
  
end)

st:setbgdraw(function(self)
  color('black')
  love.graphics.rectangle('fill',0,0,project.res.x,project.res.y)
end)
--entities are drawn here
st:setfgdraw(function(self)
  
  color('red')
  love.graphics.print(loc.get('helloworld'),10,10)
  
end)

return st