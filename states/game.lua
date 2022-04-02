local st = Gamestate:new('cubetest')

st:setinit(function(self)
  self.cube = em.init('cube',{x=project.res.cx,y=project.res.cy})
  em.init('floortile',{canv='c'})
  em.init('floortile',{canv='l'})
  em.init('floortile',{canv='r'})
  em.init('floortile',{canv='u'})
  em.init('floortile',{canv='d'})
  
  self.player = em.init('player',{x=64,y=64,canv='c'})
end)


st:setupdate(function(self,dt)
  
end)

st:setbgdraw(function(self)
  color('black')
  love.graphics.rectangle('fill',0,0,project.res.x,project.res.y)
end)
--entities are drawn here
st:setfgdraw(function(self)

  
end)

return st