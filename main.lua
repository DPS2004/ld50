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
  shuv.init()
  shuv.hackyfix()
  
  -- what it says on the tin
  utf8 = require("utf8")


  -- deeper, modification of deep, queue functions, now with even more queue
  deeper = require "lib/deeper/deeper"

  -- tesound, sound playback
  te = require"lib.tesound"



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
    
    self:updatefunc(dt)
    
    flux.update(dt)
    em.update(dt)
    te.cleanup()
  end
  
  
  function Gamestate:draw()
    shuv.start()
    
    self:bgdrawfunc()
    
    em.draw()
    self:fgdrawfunc()
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
  levels = dpf.loadjson('data/levels.json',{})
  
  for groupname, group in pairs(levels.groups) do
    if string.sub(groupname,1,4) ~= 'boss' then
      for i=1,#group do
        local v = group[i]
        local flipped = helpers.copy(v)
        for tilei,tile in ipairs(flipped) do
          tile.x = 15-tile.x
          
          if tile.t == 22 or tile.t == 23 then -- bubble centering
            tile.x = tile.x - 1
          end
          
          if groupname == 'corner' then
            local oldx = tile.x
            local oldy = tile.y
            tile.x = oldy
            tile.y = 15-oldx
            
            if tile.t == 21 then --flip bouncer enemies
              tile.t = 19
            elseif tile.t == 19 then
              tile.t = 21
            end
            
            if tile.t == 22 or tile.t == 23 then -- bubble centering
              tile.y = tile.y - 1
            end
            
            
          end
        end
        table.insert(group,flipped)
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
end