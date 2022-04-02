local st = Gamestate:new('cubetest')

st:setinit(function(self)
  self.cube = em.init('cube',{x=project.res.cx,y=project.res.cy})
  em.init('floortile',{canv='c'})
  em.init('floortile',{canv='l'})
  em.init('floortile',{canv='r'})
  em.init('floortile',{canv='u'})
  em.init('floortile',{canv='d'})
  
  self.player = em.init('player',{x=64,y=64,canv='c'})
  self.map = self:levelgen(0)
end)


function st:levelgen(floor)


  local size = 4+floor

  local map = {}
  local roomnum = 0

  local oppositedir = {u='d',d='u',l='r',r='l'}

  local function removevalue(t,v)
    local foundval = nil
    for ti,tv in ipairs(t) do
      if tv == v then
        foundval = ti
      end
    end
    table.remove(t,foundval)
  end

  local function findunlinked(id,dir,list)
    if not list then
      list = {}
      for i,v in ipairs(map) do
        table.insert(list,v.id)
      end
    end
    
    
    
    local listindex = math.random(1,#list)
    
    local roomindex = list[listindex]
    local room = map[roomindex]
    if not room then return end
    
    local isunlinked = true
    
    for k, v in pairs(room.exits) do
      if v == id then
        isunlinked = false
      end
    end
    
    
    if room.id ~= id and isunlinked and (not room.exits[oppositedir[dir]]) and #room.unlinked ~= 0 then
      
      return room
    else
      table.remove(list,listindex)
      return findunlinked(id,dir,list)
    end
  end

  local function newroom()
    local room = {}
    room.exits = {}
    room.unlinked = {}
    room.id = #map + 1
    for i,v in ipairs({'u','d','l','r'}) do
      table.insert(room.unlinked,math.random(1,#room.unlinked+1),v)
    end
    
    function room:getunlinkeddir()
      if #self.unlinked ~= 0 then
        return self.unlinked[math.random(1,#room.unlinked)]
      end
    end
    
    function room:link(tolink,dir)
      self.exits[dir] = tolink.id
      tolink.exits[oppositedir[dir]] = self.id
      removevalue(self.unlinked,dir)
      removevalue(tolink.unlinked,oppositedir[dir])
      
    end
    
    function room:settype(t)
      self.roomtype = t
      if t == 'start' then
        
      end
      
      if t == 'boss' then
        self.unlinked = {}
      end
    end
    
    table.insert(map,room)
    return room
    
  end

  local function inspectrooms()
    print('-----------------------------------------------------------------')
    for roomi,room in ipairs(map) do
      print(room.id..':')
      if room.roomtype then
        print('  type: '..room.roomtype)
      end
      print('  unlinked: ' .. string.upper(table.concat(room.unlinked)))
      local exitstr = '  exits: '
      for k,v in pairs(room.exits) do
        exitstr = exitstr .. string.upper(k)..':'..v..'  '
      end
      print(exitstr)
    end
  end

  
  print('Step 1: generate the critical path ('..(size+1)..' rooms long)')

  local startroom = newroom()
  startroom:settype('start')

  for geni = 1,size do
    local lastroom = map[#map]
    local room = newroom()
    local newdir = lastroom:getunlinkeddir()
    lastroom:link(room,newdir)
  end
  map[#map]:settype('boss')


  
  inspectrooms()
  print('Step 2: link start room to both a new room and an existing room')

  local linkroom = map[math.random(3,math.ceil(size/2)+1)]

  for di,dv in ipairs(linkroom.unlinked) do
    if map[1].exits[oppositedir[dv]] == nil then
      linkroom:link(map[1],dv)
      break
    end
  end

  map[1]:link(newroom(),map[1]:getunlinkeddir())

  map[1].unlinked = {}

  inspectrooms()
  print('Step 3: add '..math.floor(size/2)..' extra rooms')

  for geni = 1,math.floor(size/2) do
    local room = newroom()
    for nri = 1,math.random(2,3) do
      local newdir = room:getunlinkeddir()
      local linkroom = findunlinked(room.id,newdir)
      if linkroom then
        room:link(linkroom,newdir)
      end
    end
  end
  
  inspectrooms()
  return map
end




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