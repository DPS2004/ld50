local st = Gamestate:new('editor')

st:setinit(function(self)
  self.cx = 0
  self.cy = 0
  self.cursortile = 0
  self.tilequads = {}
  self.tilesize = savedata.properties.tilesize
  for x = 0,15 do
    for y = 0,3 do
      self.tilequads[y*16+x] = love.graphics.newQuad(x*8,y*8,8,8,128,32)
    end
  end
  self.mapgroup = ''
  self.mapid = 0
  
end)

function st:addtile(x,y,t)
  table.insert(self.level.tiles,{x=x,y=y,t=t})
end

function st:deleteat(x,y)
  for i,v in ipairs(self.level.tiles) do
    if v.x == x and v.y == y then
      table.remove(self.level.tiles,i)
    end
  end
  
end

function st:setuplevel()
  if #savedata.groups[self.mapgroup] == 0 then
    table.insert(savedata.groups[self.mapgroup],{})
  end
  self.level = savedata.groups[self.mapgroup][self.mapid+1]
end

st:setupdate(function(self,dt)
  if maininput:down('ctrl') then
    if maininput:pressed('n') then
      table.insert(savedata.groups[self.mapgroup],{})
      self.mapid = #savedata.groups[self.mapgroup] - 1
      self:setuplevel()
    elseif maininput:pressed('s') then
      sdfunc.save()
    elseif maininput:pressed('c') then
      copied = helpers.copy(self.level)
      
    elseif maininput:pressed('v') then
      self.level = helpers.copy(copied)
      savedata.groups[self.mapgroup][self.mapid+1] = self.level
    end
  end

  if maininput:pressed('left') then
    self.mapid = (self.mapid-1) % #savedata.groups[self.mapgroup]
    self:setuplevel()
  end
  if maininput:pressed('right') then
    self.mapid = (self.mapid+1) % #savedata.groups[self.mapgroup]
    self:setuplevel()
  end
  if maininput:pressed('back') then
    cs = bs.load('editor_mapselect')
    cs:init()
  end
  
  if helpers.tablematch(self.cursortile,savedata.properties.halfsize) then
    self.cx = math.floor(mouse.x / self.tilesize)%self.level.width
    self.cy = math.floor(mouse.y / self.tilesize)
  else
    self.cx = math.floor((mouse.x+2) / self.tilesize)%self.level.width
    self.cy = math.floor((mouse.y+2) / self.tilesize)
  end
  
  
  if self.cy < 32 then
    
    self.inmap = true
    
    if mouse.pressed >= 1 then
      st:deleteat(self.cx,self.cy)
      st:addtile(self.cx,self.cy,self.cursortile)
    end
    if mouse.altpress >= 1 then
      st:deleteat(self.cx,self.cy)
    end
  else
    
    self.inmap = false
    
    self.cx = math.floor(mouse.x / 8)%16
    self.cy = math.floor(mouse.y / 8)%20
    
    if mouse.pressed == -1 then
      self.cursortile = self.cx + (self.cy - 16) * 16
    end
  end
  
end)

st:setbgdraw(function(self)
  love.graphics.setColor(0.2,0.2,0.2,1)
  love.graphics.rectangle('fill',0,0,project.res.x,project.res.y)
end)
--entities are drawn here
st:setfgdraw(function(self)
  color()
  for i,v in ipairs(self.level.tiles) do
    if helpers.tablematch(v.t,savedata.properties.halfsize) then
      love.graphics.draw(sprites.editortiles,self.tilequads[v.t],v.x*self.tilesize,v.y*self.tilesize)
    else
      love.graphics.draw(sprites.editortiles,self.tilequads[v.t],v.x*self.tilesize,v.y*self.tilesize,0,1,1,4,4)
    end
  end
  
  love.graphics.setColor(0.8,0.8,0.8,1)
  love.graphics.draw(sprites.editortiles,0,128)
  
  color()
  
  love.graphics.draw(sprites.editortiles,self.tilequads[self.cursortile],(self.cursortile%16)*8,math.floor(self.cursortile/16)*8+128)
  
  if self.inmap then
    if mouse.altpress <= 0 then
      if helpers.tablematch(self.cursortile,savedata.properties.halfsize) then
        love.graphics.draw(sprites.editortiles,self.tilequads[self.cursortile],self.cx*self.tilesize,self.cy*self.tilesize)
      else
        love.graphics.draw(sprites.editortiles,self.tilequads[self.cursortile],self.cx*self.tilesize-4,self.cy*self.tilesize-4)
      end
    end
  else
    love.graphics.draw(sprites.editorcursor,self.cx*8,self.cy*8)
  end
  
  love.graphics.setColor(1,1,1,0.5)
  
  
  if helpers.tablematch(self.cursortile,savedata.properties.halfsize) then
    love.graphics.draw(sprites.editorcursorsmall,mouse.x-2,mouse.y-2)
  else
    love.graphics.draw(sprites.editorcursor,mouse.x-4,mouse.y-4)
  end
end)

return st