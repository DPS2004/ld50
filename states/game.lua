local st = Gamestate:new('cubetest')

st:setinit(function(self)
  self.cube = em.init('cube',{x=project.res.cx,y=project.res.y*0.55})
  local dirs = {'c','l','r','u','d'}
  
  self.rooms = {}
  self.floors = {}
  
  for i,v in ipairs(dirs) do
    self.floors[v] = em.init('floortile',{canv=v})
    self.rooms[v] = em.init('room',{canv=v})
  end
  

  
  self.player = em.init('player',{x=64,y=64,canv='c'})
  self.map = self:levelgen(0)
  
  self.croom = 1
  
  self.doortiles = {
    {x=6,y=0},{x=7,y=0},{x=8,y=0},{x=9,y=0},
    {x=6,y=15},{x=7,y=15},{x=8,y=15},{x=9,y=15},
    {x=0,y=6},{x=0,y=7},{x=0,y=8},{x=0,y=9},
    {x=15,y=6},{x=15,y=7},{x=15,y=8},{x=15,y=9},
  }
  
  --local skiptoboss = true
  
  if skiptoboss then
    self.map[1].exits = {u=5,d=5,l=5,r=5}
  end
  
  self:updaterooms()
  
  self.score = 1000
  
  self.level = 0
  
  self.pointsgained = 0
  
  self.scoredigits = {0,0,0,0,1,10,100,1000}
  
  self.scorecountdown = 30
  
  self.musbpm = 120
  
  self.scoretext = ''
  self.scoreop = 0
  self.greenscore = true
  
  st:playmusic(0)
  
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
    
    
    if #list == 0 then
      return
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
      if room.rotate then
        print('  rotate: '..room.rotate)
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
  
  for roomi,room in ipairs(map) do
    local numexits = 0
    local exdirs = {}
    local hasexit = {}
    for k,v in pairs(room.exits) do
      numexits = numexits + 1
      table.insert(exdirs,k)
      hasexit[k] = true
    end
    if not room.roomtype then
      if numexits == 1 then
        room.roomtype = 'deadend'
        if hasexit['u'] then
          room.rotate = 0
        elseif hasexit['r'] then
          room.rotate = 3
        elseif hasexit['d'] then
          room.rotate = 2
        else
          room.rotate = 1
        end
      elseif numexits == 2 then
        if exdirs[1] == oppositedir[exdirs[2]] then
          room.roomtype = 'straight'
          if hasexit['u'] then
            room.rotate = 0
          else
            room.rotate = 1
          end
        else
          room.roomtype = 'corner'
          if hasexit['u'] and hasexit['l'] then
            room.rotate = 0
          elseif hasexit['l'] and hasexit['d'] then
            room.rotate = 1
          elseif hasexit['d'] and hasexit['r'] then
            room.rotate = 2
          else
            room.rotate = 3
          end
        end
      elseif numexits == 3 then
        room.roomtype = 't'
        if not hasexit['d'] then
          room.rotate = 0
        elseif not hasexit['r'] then
          room.rotate = 1
        elseif not hasexit['u'] then
          room.rotate = 2
        else
          room.rotate = 3
        end
      else
        room.roomtype = 'cross'
        room.rotate = math.random(0,3)
      end
    else
      if room.roomtype == 'start' then
        if not hasexit['d'] then
          room.rotate = 0
        elseif not hasexit['r'] then
          room.rotate = 1
        elseif not hasexit['u'] then
          room.rotate = 2
        else
          room.rotate = 3
        end
      elseif room.roomtype == 'boss' then
        room.rotate = 0
      end
    end
  end
  inspectrooms()
  
  for roomi,room in ipairs(map) do
    if levels.groups[room.roomtype] then
      room.tiles = helpers.copy(levels.groups[room.roomtype][math.random(1,#levels.groups[room.roomtype])])
      print(room.roomtype,room.rotate)
      
      for tilei,tile in ipairs(room.tiles) do
        if tile.t == 0 or tile.t == 2 then
          tile.solid = true
          tile.hp = 4
        end
      end
      
      for i=1,room.rotate do
        for tilei,tile in ipairs(room.tiles) do
          local oldx = tile.x
          local oldy = tile.y
          tile.x = oldy
          tile.y = 15-oldx
          
          if tile.t == 21 then --flip bouncer enemies
            tile.t = 19
          elseif tile.t == 19 then
            tile.t = 21
          end
          
          if tile.t == 22 then -- bubble centering
            tile.y = tile.y - 1
          end
          
        end
      end
      
      
    end
    
    if room.roomtype == 'start' then
      room.cleared = true
    elseif room.roomtype == 'boss' then
      room.entered = false
      room.cleared = false
      room.exits['u'] = room.id
      room.exits['d'] = room.id
      room.exits['l'] = room.id
      room.exits['r'] = room.id
    else
      room.cleared = false
    end
    
  end
  return map
end


function st:updaterooms()
  local mainroom = self.map[self.croom]
  self.rooms['c'].level = mainroom
  self.rooms['u'].level = self.map[mainroom.exits.u]
  self.rooms['d'].level = self.map[mainroom.exits.d]
  self.rooms['l'].level = self.map[mainroom.exits.l]
  self.rooms['r'].level = self.map[mainroom.exits.r]
  
  self.floors['c'].level = mainroom
  self.floors['u'].level = self.map[mainroom.exits.u]
  self.floors['d'].level = self.map[mainroom.exits.d]
  self.floors['l'].level = self.map[mainroom.exits.l]
  self.floors['r'].level = self.map[mainroom.exits.r]
  
  if not mainroom.cleared then
    if (mainroom.roomtype ~= 'boss') or (not mainroom.entered) then
      print('spawning enemies')
      mainroom.entered = true
      for tilei,tile in ipairs(mainroom.tiles) do
        
        
        
        if tile.t == 16 then
          em.init('spawner',{x=tile.x*8+4,y=tile.y*8+5,tospawn='shooter',canv='c'})
        end
        
        if tile.t == 17 then
          em.init('spawner',{x=tile.x*8+4,y=tile.y*8+5,tospawn='walker',canv='c'})
        end
        
        if tile.t == 18 then
          em.init('spawner',{x=tile.x*8+4,y=tile.y*8+5,tospawn='walkshoot',canv='c'})
        end
        
        if tile.t == 19 then
          em.init('spawner',{x=tile.x*8+4,y=tile.y*8+5,tospawn='bouncer',canv='c',eparams={angle=90}})
        end
        
        if tile.t == 20 then
          em.init('spawner',{x=tile.x*8+4,y=tile.y*8+5,tospawn='cannon',canv='c'})
        end
        
        if tile.t == 21 then
          em.init('spawner',{x=tile.x*8+4,y=tile.y*8+5,tospawn='bouncer',canv='c',eparams={angle=0}})
        end
        
        if tile.t == 22 then
          em.init('spawner',{x=tile.x*8+8,y=tile.y*8+8,tospawn='bubble',finalsize=8,canv='c'})
        end
        
        --bosses
        if tile.t == 32 then
          self:playmusic(1)
          em.init('spawner',{x=tile.x*8+8,y=tile.y*8+8,tospawn='spinner',finalsize=8,canv='c',eparams={angle=0}})
        end
        
      end
    end
  end
  
  
end

function st:addscore(num,text)
  self.score = self.score + num
  self.scoreop = 1.5
  self.scoretext = ''
  
  self.greenscore = num > 0
  if self.greenscore then
    self.scoretext = '+'
    self.pointsgained = self.pointsgained + num
  else
    self.scoretext = ''
  end
  self.scoretext = self.scoretext .. num .. ' ' .. loc.get(text)
end

function st:playmusic(m)
  m = m or 0
  
  te.stop('bgm',false)
  
  if m == 1 then --boss
    self.musbpm = 150
    te.play("assets/music/boss_intro.ogg","stream","bgm",1.1,1,function(a)
      te.playLooping("assets/music/boss.ogg","stream","bgm",1.1)
    end)
  else --main/fallback
    self.musbpm = 120
    te.play("assets/music/ld50mus_intro.ogg","stream","bgm",1,1,function(a)
      te.playLooping("assets/music/ld50mus.ogg","stream","bgm")
    end)
  end
  
  self.scorecountdown = 3600 / self.musbpm
end

st:setupdate(function(self,dt)
  self.scoreop = self.scoreop - (dt/40)
  
  self.scorecountdown = self.scorecountdown - dt
  if self.scorecountdown <= 0 then
    self.scorecountdown = self.scorecountdown + (3600 / self.musbpm)
    self.score = self.score - 1
  end

  if self.score <= 0 then
    print("imagine losing lmao")
    for i,v in pairs(entities) do
      v.delete = true
      v.skipupdate = true
    end
    self.dead = true
    local highscore = savedata.highscore or 0
    savedata.highscore = math.max(highscore, self.pointsgained)
    sdfunc.save()
    te.stop('bgm',false)
    
    cs = bs.load('menu')
    cs:init(true, self.pointsgained, self.pointsgained > highscore)
    return
  end
  
  if (not self.map[self.croom].cleared) then
    local enemiesleft = false
    for i,v in ipairs(entities) do
      if v.isenemy then
        enemiesleft = true
      end
    end
    
    if not enemiesleft then
      self.map[self.croom].cleared = true
      cs:addscore(50,'clearedroom')
      em.init('clearparticles',{x=0,y=0,canv = 'c'})
      te.play('assets/sfx/room_clear.ogg','static',{'room_clear','sfx'},1.5)
    end
    
  end
end)

st:setbgdraw(function(self)
  color('black')
  love.graphics.rectangle('fill',0,0,project.res.x,project.res.y)
  color('white')
  shuv.do_autoscaled(function() love.graphics.draw(sprites.stage,0,0) end)
end)

--entities are drawn here
st:setfgdraw(function(self)
  shuv.do_autoscaled(function()
    color()
    love.graphics.draw(sprites.scorecounter,0,0)
    love.graphics.setScissor(117 * shuv.internal_scale, 5 * shuv.internal_scale, 119 * shuv.internal_scale, 15 * shuv.internal_scale) 
    
    
    --draw score
    
    for i,v in ipairs(self.scoredigits) do
      self.scoredigits[i] = (self.scoredigits[i]*3 + math.floor(self.score/10^(8-i)))/4
      love.graphics.draw(sprites.numbers,102+i*15,-155+(self.scoredigits[i]%10)*16)
    end
    
    love.graphics.setScissor()
    if self.greenscore then
      love.graphics.setColor(76/255,1,0,helpers.clamp(self.scoreop,0,1))
    else
      love.graphics.setColor(1,0,77/255,helpers.clamp(self.scoreop,0,1))
    end
    love.graphics.printf(self.scoretext,134,20,84,'center')
  end)
  
end)

return st