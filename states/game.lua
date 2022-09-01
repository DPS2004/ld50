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
  
  self.score = 1000
  self.scoredigits = {0,0,0,0,1,10,100,1000}
  self.scorecountdown = 30
  
  self.pointsgained = 0
  
  self.scoretext = ''
  self.scoreop = 0
  self.greenscore = true
  
  self.roomscleared = 0
  
  self.bosslist = {
    'spinner',
    'crusher'
  }
  self.unseenbosses = {}
  for i,v in ipairs(self.bosslist) do
    table.insert(self.unseenbosses,v)
  end

  
  
  if not self.playtutorial then
    self.map = self:levelgen(0)
    
    self.croom = 1
    
    self.level = 0
    
    --local skiptoboss = true
    
    if skiptoboss then
      self.map[1].exits = {u=5,d=5,l=5,r=5}
    end
    
    self.musbpm = 120
    
    self:playmusic(0)
    
  else
    print('starting game in tutorial mode')
    
    self.croom = 1
    
    self.musbpm = 128
    
    self.tutorialsecretfound = false
    
    --self.skiptotutorialsecret = true
    
    self.secretary = em.init('secretary',{canv = 'c'})
    
    self.playstatic = false
    
    self:playmusic(2)
    
    
    self.tutorialfunc = nil
    
    --[[
    local loadtiles = function(id)
      local tiles = helpers.copy(levels.groups.tutorial[id].tiles)
      for tilei,tile in ipairs(tiles) do
        if tile.t == 0 or tile.t == 2 or tile.t == 3 then
          tile.solid = true
          tile.hp = 4
          if tile.t == 3 then
            tile.bulletpass = true
          end
        end
      end
      if id == 1 then
        for y = 6,9 do
          table.insert(tiles,{x=0,y=y*2,t=0,solid=true,todelete=true})
          table.insert(tiles,{x=1,y=y*2,t=0,solid=true,todelete=true})
          table.insert(tiles,{x=0,y=y*2+1,t=0,solid=true,todelete=true})
          table.insert(tiles,{x=1,y=y*2+1,t=0,solid=true,todelete=true})
        end
        
      end
      if id == 4 then
        for y=1,14 do
          table.insert(tiles,{x=4,y=y,t=0,solid=true,todelete=true})
        end
      end
      return tiles
    end
    ]]--
    
    self.map = {}
    
    for i=1,4 do
      table.insert(self.map,{
        id = i,
        staylocked = (i==1 or i==2),
        cleared = false,
        exits = {r = i+1,l=i-1},
        toload = i
      })
    end
    self.map[1].exits.l = 10
    
    table.insert(self.map,{
      id = 5,
      staylocked = true,
      cleared = false,
      exits = {l=4,u = 6,d = 7},
      toload = 5
    })
    table.insert(self.map,{
      id = 6,
      cleared = false,
      exits = {u = 8,d = 5},
      toload = 6
    })
    table.insert(self.map,{
      id = 7,
      cleared = false,
      exits = {u = 5,d = 8},
      toload = 7
    })
    table.insert(self.map,{
      id = 8,
      cleared = false,
      exits = {u = 7,d = 6,l=9},
      toload = 8
    })
    table.insert(self.map,{
      id = 9,
      cleared = false,
      staylocked = true,
      exits = {r=8},
      toload = 9
    })
  
  
    table.insert(self.map,{
      id = 10,
      cleared = true,
      staydark = true,
      exits = {l=11,r=1},
      toload = 10
    })
    table.insert(self.map,{
      id = 11,
      cleared = true,
      staydark = true,
      exits = {l=12,r=10},
      toload = 10
    })
    table.insert(self.map,{
      id = 12,
      cleared = true,
      staydark = true,
      tutorialsecret = true,
      exits = {r=11},
      toload = 11
    })
    for i,v in ipairs(self.map) do
      loadroom(v,levels.groups.tutorial[v.toload])
    end
    
    local diasounds = {}
    for i=0,37 do
      table.insert(diasounds,'assets/sfx/talk/'..i..'.ogg')
    end
    
    local dspeed = 1
    
    local dialogs = {
      {t=loc.get('tutorial1'),l=80,w=150,n=2}, --Hi, good to see you.
      {t=loc.get('tutorial2'),l=240,w=286,n=3}, --We're going live soon, so let's get you acquainted with the way this all works.
      {t=loc.get('tutorial3'),l=200,w=250,n=function(self) --Try moving around with WASD, and shooting with the Arrow Keys.
        if not self.movetimer then self.movetimer = 0 self.shoottimer = 0 end
        if (maininput:down('left') or maininput:down('right') or maininput:down('up') or maininput:down('down')) then
          self.movetimer = self.movetimer + 1
        end
        if (maininput:down('shootleft') or maininput:down('shootright') or maininput:down('shootup') or maininput:down('shootdown')) then
          self.shoottimer = self.shoottimer + 1
        end
        if self.shoottimer >= 200 and self.movetimer >= 200 then
          if not (self.skiptotutorialsecret) then
            self.playdialog(4)
          end
          self.map[self.croom].staylocked = false
          return true
        end
      end
      },
      {t=loc.get('tutorial4'),l=80,w=150,n=function(self)--Great. Move into the next room, please.
        if self.croom ~= 1 then
          self.playdialog(5)
          return true
        end
      end
      },
      {t=loc.get('tutorial5'),l=80,w=200,n=function(self)--Defeat the enemy in the center of the screen.
        local enemiesleft = false
        for i,v in ipairs(entities) do
          if v.isenemy then
            enemiesleft = true
          end
        end
        
        if not enemiesleft then
          self.playdialog(6)
          return true
        end
      end
      }, 
      {t=loc.get('tutorial6'),l=40,w=80,n=7}, --Good job.
      {t=loc.get('tutorial7'),l=240,w=280,n=8}, --You have probably noticed the score display on the top of the screen.
      {t=loc.get('tutorial8'),l=280,w=336,n=9}, --Your score increases when you defeat enemies, clear rooms, or things of that nature.
      {t=loc.get('tutorial9'),l=200,w=200,n=10}, --But your score steadily decreases as time passes.
      {t=loc.get('tutorial10'),l=190,w=170,n=11}, --It also goes down quite a bit when you get hit.
      {t=loc.get('tutorial11'),l=190,w=176,n=12}, --If your score reaches 0, the game will end.
      {t=loc.get('tutorial12'),l=190,w=230,n=13,onclear = function(self) --Don't worry, for this tutorial your score will never go below 500.
        print('aeiou')
        self.map[self.croom].staylocked = false
      end
      },
      {t=loc.get('tutorial13'),l=60,w=130,n=function(self)--Next room, please.
        if self.croom == 3 then
          self.playdialog(14)
          print('clearing 13')
          return true
        end
      end
      },
      {t=loc.get('tutorial14'),l=100,w=230,n=function(self)--This room has two enemies in it. Defeat them both, and move on.
        if self.croom == 4 then
          self.playdialog(15)
          return true
        end
      end
      }, 
      {t=loc.get('tutorial15'),l=60,w=100,n=16}, --Do you see those boxes?
      {t=loc.get('tutorial16'),l=240,w=300,n=17,onclear = function(self)--You can pick up and aim them with the arrow keys, and throw them with space.
        modifyroom(self.map[4],'cmdbreak')
      end
      },
      {t=loc.get('tutorial17'),l=60,w=100,n=function() --Go ahead, try it out.
        local enemiesleft = false
        for i,v in ipairs(entities) do
          if v.isenemy then
            enemiesleft = true
          end
        end
        
        if not enemiesleft then
          self.playdialog(18)
          return true
        end
      end
      }, 
      {t=loc.get('tutorial18'),l=45,w=80,n=function() --Nicely done.
        local enemiesleft = false
        for i,v in ipairs(entities) do
          if v.isenemy then
            enemiesleft = true
          end
        end
        
        if (not enemiesleft)  and (self.croom == 5) then
          self.playdialog(19)
          return true
        end
      end
      },
      {t=loc.get('tutorial19'),l=70,w=110,n=20}, --This room has two exits.
      {t=loc.get('tutorial20'),l=160,w=280,n=21}, --If you find yourself lost, remember that unvisited rooms have a lighter floor.
      {t=loc.get('tutorial21'),l=140,w=270,onclear = function(self)--I must go now, but I trust you to make it to the main stage. Good luck.
        self.map[self.croom].staylocked = false
      end
      }, 
      
      {t=loc.get('tutorialsecret1'),l=50,w=60,n=23},
      {t=loc.get('tutorialsecret2'),l=90,w=200,n=24}, 
      {t=loc.get('tutorialsecret3'),l=50,w=100,n=function(self) 
        if self.croom ~= 12 then
          return true
        end
      end},
    
    }
    
    
    self.playdialog = function(id)
      print('dialog '..id)
      local params = {
        x=-352,y=190,
        width = dialogs[id].w,height = 34,
        tailoffset = 28,
        length = dialogs[id].l*dspeed,
        text=dialogs[id].t,
        showbutton = (type(dialogs[id].n) == 'number' or (not dialogs[id].n)),
        autostart = false,
        sound = diasounds,
        buttoncallback = function(oldbubble)
          if dialogs[id].onclear then dialogs[id].onclear(self) end
          rw:ease(0,1,'inCubic',250,oldbubble,'y')
          if type(dialogs[id].n) == 'number' then
            rw:func(0.25,function() self.playdialog(dialogs[id].n) end)
          end
          rw:func(1,function() oldbubble:cleanup() end)
          rw:play({bpm = 120})
        end
      }
      if dialogs[id].n and (type(dialogs[id].n) ~= 'number') then
        params.buttoncallback = nil
        self.tutorialfunc = dialogs[id].n
      end
          
      
      local newbubble = em.init('speechbubble',params)
      
      if dialogs[id].n and (type(dialogs[id].n) ~= 'number') then
        self.newerbubble = newbubble
        self.newtutorialfunc = dialogs[id].n
        if not self.oldbubble then
          self.oldbubble = self.newerbubble
        end
      end
      
      rw:ease(0,1,'outCubic',1,newbubble,'x')
      rw:func(1,function() newbubble:start() end)
      rw:play({bpm=120})
      
      cs.currentbubble = newbubble
    end
    
    self.endtutorial = function(self)
      savedata.skiptutorial = true
      self.pointsgained = 0
      self.playtutorial = false
      self.level = 0
      cs.map = cs:levelgen(cs.level)

      cs.croom = 1
      cs.player.x = 64
      cs.player.y = 64
      cs:updaterooms()
      cs:playmusic(0)
      
    end
    
    
    self.playdialog(1)
    
    
  end
  
  self:updaterooms()
  
  
  
  
  
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
    if levels.groups[room.roomtype] or room.roomtype == 'boss' then
      
      if room.roomtype ~= 'boss' then
        loadroom(room,levels.groups[room.roomtype][math.random(1,#levels.groups[room.roomtype])])
        
      else
        local loadboss = table.remove(self.unseenbosses,math.random(1,#self.unseenbosses))
        print('setting boss to '..loadboss)
        loadroom(room,levels.groups['boss_'..loadboss][math.random(1,#levels.groups['boss_'..loadboss])])
        
        if #self.unseenbosses == 0 then
          print('repopulating boss table')
          for i,v in ipairs(self.bosslist) do
            if v ~= loadboss then
              table.insert(self.unseenbosses,v)
            end
          end
        end
        
      end
      print(room.roomtype,room.rotate)
      
      --[[
      for tilei,tile in ipairs(room.tiles) do
        if tile.t == 0 or tile.t == 2  or tile.t == 3 then
          tile.solid = true
          tile.hp = 4
          if tile.t == 3 then
            tile.bulletpass = true
          end
        end
      end
      ]]--
      modifyroom(room,'rotate',room.rotate)
      
      
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
  
  -- add "ruined" rooms to blank sides
  
  local ruined = {}
  
  for roomi,room in ipairs(map) do
    if not room.ruined then
      for dir,_ in pairs(oppositedir) do
        if not room.exits[dir] then
          local newruined = nil
          if math.random(0,1)==0 or #ruined == 0 then
            newruined = newroom()
            newruined.ruined = true
            loadroom(newruined,levels.groups['ruined'][math.random(1,#levels.groups['ruined'])])
            
            modifyroom(newruined,'rotate',math.random(0,3))
            table.insert(ruined,newruined)
            
          else
            newruined = ruined[math.random(1,#ruined)]
          end
          room:link(newruined,dir)
        end
      end
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
        
        if tile.t == 15 then
          em.init('blackhole',{x=64,y=64,canv='c'})
        end
        
        if tile.t == 16 then
          em.init('spawner',{x=tile.x*levels.properties.tilesize,y=tile.y*levels.properties.tilesize+1,tospawn='shooter',canv='c'})
        end
        
        if tile.t == 17 then
          em.init('spawner',{x=tile.x*levels.properties.tilesize,y=tile.y*levels.properties.tilesize+1,tospawn='walker',canv='c'})
        end
        
        if tile.t == 18 then
          em.init('spawner',{x=tile.x*levels.properties.tilesize,y=tile.y*levels.properties.tilesize+1,tospawn='walkshoot',canv='c'})
        end
        
        if tile.t == 19 then
          em.init('spawner',{x=tile.x*levels.properties.tilesize,y=tile.y*levels.properties.tilesize+1,tospawn='bouncer',canv='c',eparams={angle=90}})
        end
        
        if tile.t == 20 then
          em.init('spawner',{x=tile.x*levels.properties.tilesize,y=tile.y*levels.properties.tilesize+1,tospawn='cannon',canv='c'})
        end
        
        if tile.t == 21 then
          em.init('spawner',{x=tile.x*levels.properties.tilesize,y=tile.y*levels.properties.tilesize+1,tospawn='bouncer',canv='c',eparams={angle=0}})
        end
        
        if tile.t == 22 then
          em.init('spawner',{x=tile.x*levels.properties.tilesize,y=tile.y*levels.properties.tilesize,tospawn='bubble',finalsize=8,canv='c'})
        end
        
        if tile.t == 23 then
          em.init('spawner',{x=tile.x*levels.properties.tilesize,y=tile.y*levels.properties.tilesize,tospawn='target',finalsize=8,canv='c'})
        end
        
        --bosses
        if tile.t == 32 then
          self:playmusic(1)
          em.init('spawner',{x=tile.x*levels.properties.tilesize,y=tile.y*levels.properties.tilesize,tospawn='spinner',finalsize=8,canv='c',eparams={angle=0}})
        end
        
        if tile.t == 33 then
          self:playmusic(1)
          em.init('spawner',{x=tile.x*levels.properties.tilesize,y=tile.y*levels.properties.tilesize,tospawn='crusher',finalsize=10,canv='c',spawnoffset = 0})
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
      te.playLooping("assets/music/boss.ogg","stream","bgm",nil,1.1)
    end)
  elseif m == 2 then --tutorial
    self.musbpm = 128.6
    te.playLooping("assets/music/tutorial.ogg","stream","bgm",nil,1)
  elseif m == 3 then --tutorial
    self.musbpm = 0
    te.playLooping("assets/music/static.ogg","stream","bgm",nil,0.5)
  else --main/fallback
    self.musbpm = 120
    te.play("assets/music/ld50mus_intro.ogg","stream","bgm",1,1,function(a)
      te.playLooping("assets/music/ld50mus.ogg","stream","bgm")
    end)
  end
  
  if self.musbpm ~= 0 then
    self.scorecountdown = 3600 / self.musbpm
  end
end

st:setupdate(function(self,dt)
  self.scoreop = self.scoreop - (dt/40)
  
  self.scorecountdown = self.scorecountdown - dt
  if self.scorecountdown <= 0 then
    if self.musbpm ~= 0 then
      self.scorecountdown = self.scorecountdown + (3600 / self.musbpm)
      self.score = self.score - 1
      if self.player.blocking then
        self.score = self.score - 1
      end
    end
  end
  
  if self.playtutorial then
    
    if (self.roomscleared >= 8 or self.skiptotutorialsecret) and (not self.tutorialsecretfound)  then
      self.tutorialsecretfound = true
      te.play('assets/sfx/room_clear_echo.ogg','static',{'room_clear_echo','sfx'},1.5)
      modifyroom(self.map[1],'cmdbreak')
    end
    
    if self.croom == 10 and (not self.playstatic) then
      self.playstatic = true
      self:playmusic(3)
    end
    
    if self.score < 500 then
      self.score = self.score + 10
    end
  end

  if self.score <= 0 then
    print("imagine losing lmao")
    rw:stopall()
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
    
    if self.map[self.croom].staylocked then
      enemiesleft = true
    end
    
    for i,v in ipairs(entities) do
      if v.isenemy then
        enemiesleft = true
      end
    end
    
    if not enemiesleft then
      self.roomscleared = self.roomscleared + 1
      self.map[self.croom].cleared = true
      cs:addscore(50,'clearedroom')
      em.init('clearparticles',{x=0,y=0,canv = 'c'})
      te.play('assets/sfx/room_clear.ogg','static',{'room_clear','sfx'},1.5)
    end
    
  end
  
  if self.tutorialfunc then
    if self:tutorialfunc() then
      print('tutorialfunc success')
      self.tutorialfunc = nil
      rw:ease(0,1,'inCubic',250,self.oldbubble,'y')
      rw:func(1,function() self.oldbubble:cleanup() print(self.oldbubble.delete) self.oldbubble = nil if self.newerbubble then print('swapping bubbles') self.oldbubble = self.newerbubble self.tutorialfunc = self.newtutorialfunc self.newerbubble = nil self.newtutorialfunc = nil end end)
      rw:play({bpm = 120})
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
    love.graphics.setFont(fonts.main)
    if self.greenscore then
      love.graphics.setColor(76/255,1,0,helpers.clamp(self.scoreop,0,1))
    else
      love.graphics.setColor(1,0,77/255,helpers.clamp(self.scoreop,0,1))
    end
    love.graphics.printf(self.scoretext,134,20,84,'center')
  end)
  
end)

return st