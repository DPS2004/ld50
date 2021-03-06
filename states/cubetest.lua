local st = Gamestate:new('cubetest')

st:setinit(function(self)
  self.cube = em.init('cube',{x=project.res.cx,y=project.res.cy})
  self.templateobj = em.init('templateobj',{x=64,y=64,r=0,canv='c'})
  self.templateobj = em.init('templateobj',{x=64,y=64,r=90,canv='l'})
  self.templateobj = em.init('templateobj',{x=64,y=64,r=-90,canv='r'})
  self.templateobj = em.init('templateobj',{x=64,y=64,r=180,canv='u'})
  self.templateobj = em.init('templateobj',{x=64,y=64,r=0,canv='d'})
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