g3d = require('lib/g3d')
function love.load()
  dofile = function(fname) love.filesystem.load(fname)() end
  dt = 1
  
  freeze = 0
  
  -- set rescaling filter
  love.graphics.setDefaultFilter("nearest", "nearest")
  
  love.graphics.setLineStyle("rough")
  love.graphics.setLineJoin("miter")
  
  fonts ={
    main = love.graphics.newFont("assets/fonts/Axmolotl.ttf", 16),
    pico = love.graphics.newFont("assets/fonts/PICO-8 wide.ttf", 4),
    disco = love.graphics.newFont("assets/fonts/DigitalDisco-Thin.ttf", 16)
  }
  
  -- font is https://tepokato.itch.io/axolotl-font
  
  for i,v in ipairs(fonts) do
    v:setFilter("nearest", "nearest",0)
  end
  
  love.graphics.setFont(fonts.main)
  
  -- import libraries
  
  -- json handler
  json = require "lib.json" -- i would use a submodule, but the git repo has .lua in the name??????
  
  -- custom functions, snippets, etc
  helpers = require "lib.helpers"
  
  -- quickly load json files
  dpf = require "lib.dpf"
  
  -- localization
  loc = require "lib.loc"
  loc.load("data/localization.json")
  

  -- manages gamestates
  bs = require "lib.basestate"

  -- baton, manages input handling
  baton = require "lib/baton/baton"

  shuv = require "lib.shuv"
  shuv.init(project)
  shuv.hackyfix()
  
  -- what it says on the tin
  utf8 = require("utf8")


  -- deeper, modification of deep, queue functions, now with even more queue
  deeper = require "lib/deeper/deeper"

  -- tesound, sound playback
  te = require"lib.tesound"


  -- jprof, profiling
  
  PROF_CAPTURE = project.doprofile
  
  prof = require "lib/profiling/jprof"
  
  prof.enabled(project.doprofile)
  
  if project.doprofile then
    print("profiling enabled!")
  end

  -- lovebird,debugging console
  if (not project.release)  then 
    lovebird = require "lib/lovebird/lovebird"
  else
    lovebird = require "lib.lovebirdstripped"
  end

  -- entity manager
  em = require "lib.entityman"

  -- spritesheet manager
  ez = require "lib.ezanim"

  -- tween manager
  flux = require "lib/flux/flux"
  
  rw = require "lib/ricewine"
  
  class = require "lib/middleclass/middleclass"
  
  Gamestate = class('Gamestate')
  
  function Gamestate:initialize(name)
    self.name = name or 'newstate'
    self.updatefunc = function() end
    self.bgdrawfunc = function() end
    self.fgdrawfunc = function() end
  end
  
  function Gamestate:setinit(initfunc)
    self.initfunc = initfunc
  end
    
  function Gamestate:setupdate(updatefunc)
    self.updatefunc = updatefunc
  end
  
  function Gamestate:setbgdraw(drawfunc)
    self.bgdrawfunc = drawfunc
  end
  
  function Gamestate:setfgdraw(drawfunc)
    self.fgdrawfunc = drawfunc
  end
  
  function Gamestate:init(...)
    self:initfunc(...)
  end
  
  function Gamestate:update(dt)
    maininput:update()
    lovebird.update()
    helpers.updatemouse()
    
    prof.push("gamestate update")
    self:updatefunc(dt)
    prof.pop("gamestate update")
    
    prof.push("ricewine update")
    rw:update()
    prof.pop("ricewine update")
    
    prof.push("flux update")
    flux.update(dt)
    prof.pop("flux update")
    
    prof.push("entityman update")
    em.update(dt)
    prof.pop("entityman update")
    
    te.cleanup()
  end
  
  
  function Gamestate:draw()
    shuv.start()
    
    prof.push("bg draw")
    self:bgdrawfunc()
    prof.pop("bg draw")
    
    prof.push("entityman draw")
    em.draw()
    prof.pop("entityman draw")
    
    prof.push("fg draw")
    self:fgdrawfunc()
    prof.pop("fg draw")
    
    love.graphics.setColor(1,1,1,1)
    shuv.finish()
  end
  
  
  
  Entity = class('Entity')
  
  
  function Entity:initialize(params)
    params = params or {}
    self.layer = self.layer or 0
    self.uplayer = self.uplayer or 0
    self.delete = false
    
    for k,v in pairs(params) do
      self[k] = v
    end
  end
  
  function Entity:update(dt)
  end
  function Entity:draw(dt)
  end
  
  
  
  love.window.setTitle(project.name)
  paused = false

  --load sprites

  sprites = require('preload.sprites')
  
  -- make ezanim templates
  templates = require('preload.templates')

  
  -- make quads
  
  quads = require('preload.quads')
  
  
  -- load shaderss
  
  shaders = require('preload.shaders')
  
  --colors
  colors = require('preload.colors')
  
  function color(c)
    c = c or 'white'
    love.graphics.setColor(colors[c])    
  end

  
  
  
  
  

  print("setting up controls")

  
  
  maininput = baton.new {
    controls = project.ctrls,
    pairs = {
      udlr = {"up", "down","left", "right"}
    },
      joystick = love.joystick.getJoysticks()[1],
  }
  
  
  -- load savefile
  local defaultsave = dpf.loadjson(project.defaultsaveloc)
    
  if project.nosaves then
    savedata = defaultsave
  else
    savedata = dpf.loadjson(project.saveloc,defaultsave)
  end
  
  
  
  
  if project.name ~= 'roomedit' then
    savedata.timesbooted = savedata.timesbooted + 1
  end
  
  sdfunc = {}
  function sdfunc.save()
    dpf.savejson(project.saveloc,savedata)
  end
  
  function sdfunc.updatevol()
    if project.name ~= 'roomedit' then
      te.volume('sfx',savedata.options.audio.sfxvolume/10)
      te.volume('music',savedata.options.audio.sfxvolume/10)
    end
  end
  
  sdfunc.updatevol()
  sdfunc.save()

  entities = {}
  -- load entities
  dofile('preload/entities.lua')
  
  -- load states

  dofile('preload/states.lua')
  
  
  -- load levels
  
  
  
  if project.name == 'roomedit' then
    levels = savedata
  else
    levels = dpf.loadjson('data/levels.json',{})
  end
  
  function loadroom(newroom,room)
    newroom.tiles = helpers.copy(room.tiles)
    newroom.width = room.width
    newroom.height = room.height
    
    for tilei,tile in ipairs(newroom.tiles) do
      if tile.t == 0 then -- wall tile
        tile.solid = true
      elseif tile.t == 2 then -- block
        tile.solid = true
        tile.hp = 4
      elseif tile.t == 3 then -- bullet passable 
        tile.solid = true
        tile.bulletpass = true
      elseif tile.t == 4 then -- wall tile
        tile.wall = true
      elseif tile.t == 5 then -- command breakable tile 
        tile.solid = true
        tile.cmdbreak = true
      end
    end
    
  end
  
  function modifyroom(room,mod,param)
    
    
    if mod == 'rotate' then
      param = param or 1
      for i=1,param do
        for tilei,tile in ipairs(room.tiles) do
          local oldx = tile.x
          local oldy = tile.y
          tile.x = oldy
          if helpers.tablematch(tile.t,levels.properties.halfsize) then
            tile.y = (room.width - 1)-oldx
          else
            tile.y = (room.width)-oldx
          end
          
          if tile.t == 21 then --flip bouncer enemies
            tile.t = 19
          elseif tile.t == 19 then
            tile.t = 21
          end
          
          if tile.t == 22 or tile.t == 23 then -- bubble centering
            tile.y = tile.y - 1
          end
          room.tiles[tilei] = tile
        end
        
      end
    end
    
    if mod == 'flip' then
      param = param or 'x'
      if param == 'y' then
        
        for tilei,tile in ipairs(room.tiles) do
          if helpers.tablematch(tile.t,levels.properties.halfsize) then
            tile.y = (room.height - 1)-tile.y
          else
            tile.y = (room.height)-tile.y
          end
          
          if tile.t == 22 or tile.t == 23 then -- bubble centering
            tile.y = tile.y - 1
          end
          
          room.tiles[tilei] = tile
        end
        
      else
        for tilei,tile in ipairs(room.tiles) do
          if helpers.tablematch(tile.t,levels.properties.halfsize) then
            tile.x = (room.width - 1)-tile.x
          else
            tile.x = (room.width)-tile.x
          end
          
          if tile.t == 22 or tile.t == 23 then -- bubble centering
            tile.x = tile.x - 1
          end
          
          room.tiles[tilei] = tile
        end
      end
    end
    
    if mod == 'cmdbreak' then
      local newtiles = {}
      for tilei,tile in ipairs(room.tiles) do
        if not tile.cmdbreak then
          table.insert(newtiles,tile)
        end
      end
      room.tiles = newtiles
      
    end
    
    
  end
  
  if project.name ~= 'roomedit' then -- i should move this function somewhere else
    print('making room variations')
    for groupname, group in pairs(levels.groups) do
      if string.sub(groupname,1,4) ~= 'boss' then
        for i=1,#group do
          local v = group[i]
          local flipped = helpers.copy(v)
            modifyroom(flipped,'flip')
          if groupname == 'corner' then
            modifyroom(flipped,'rotate')
          end
          table.insert(group,flipped)
        end
      
      end
    end
  end
  
  toswap = nil
  newswap = false
  
  cs = bs.load(project.initstate)
  cs:init()
  
end

function love.textinput(t)
  tinput = t
end

function love.update(d)
  prof.push("frame")

  if (not project.frameadvance) or maininput:pressed("k1") or maininput:down("k2") then
    debugprint = true

    shuv.check()
    if not project.acdelt then
      dt = 1
    else
      dt = d * 60
    end
    if dt >=6 then
      dt = 6
    end
    
    if freeze <= 0 then
      cs:update(dt)
    else
      freeze = freeze - dt
    end
    
    
  end
end

function love.draw()
  cs:draw()
  debugprint = false
  prof.pop("frame")
end



function love.quit()
  if project.doprofile then
    print('saving profile')
    prof.write("prof.mpack")
  end
end