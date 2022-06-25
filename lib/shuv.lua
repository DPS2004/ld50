local shuv = {
  scale = 5,
  internal_scale = 1,
  update = true,
  xoffset = 0,
  yoffset = 0,
  screensize_canvases = {}
}

function shuv.makeCanvas()
  local c = love.graphics.newCanvas(project.res.x * shuv.internal_scale, project.res.y * shuv.internal_scale)

  local index = #shuv.screensize_canvases + 1
  local canvas = {
    canvas = c,
    index = index
  }
  shuv.screensize_canvases[index] = canvas
  return canvas
end

function shuv.deleteCanvas(canvas) 
  canvas.canvas:release()
  table.remove(shuv.screensize_canvases, canvas.index)
end

function shuv.init(project)
  shuv.canvas = love.graphics.newCanvas(project.res.x * shuv.internal_scale, project.res.y * shuv.internal_scale)
  shuv.lastframe = love.graphics.newCanvas(project.res.x * shuv.internal_scale, project.res.y * shuv.internal_scale)
  shuv.scale = project.res.s
  if project.intscale then
	shuv.internal_rescale(project.intscale)
  end
end

function shuv.internal_rescale(scale)
  shuv.internal_scale = scale
  shuv.canvas = love.graphics.newCanvas(project.res.x * shuv.internal_scale, project.res.y * shuv.internal_scale)
  shuv.lastframe = love.graphics.newCanvas(project.res.x * shuv.internal_scale, project.res.y * shuv.internal_scale)
  for _, v in ipairs(shuv.screensize_canvases) do
    v.canvas = love.graphics.newCanvas(project.res.x * shuv.internal_scale, project.res.y * shuv.internal_scale)
  end
end

function shuv.hackyfix()
  local olddraw = love.graphics.draw
  love.graphics.draw = function(...)
    local arg = {...}
    if type(arg[2]) == 'number' then
      arg[2] = math.floor(arg[2]+0.5)
      arg[3] = math.floor(arg[3]+0.5)
    else
      if arg[2] then
        arg[3] = math.floor(arg[3]+0.5)
        arg[4] = math.floor(arg[4]+0.5)
      else
        arg[2] = 0
        arg[3] = 0
      end
    end
    olddraw(unpack(arg))
  end
end

function shuv.do_autoscaled(func)
  love.graphics.push()
  love.graphics.scale(shuv.internal_scale, shuv.internal_scale)
  func()
  love.graphics.pop()
end

function shuv.check()
  if not ismobile then
    if maininput:pressed("k3") then
      shuv.internal_rescale(shuv.internal_scale - 1)
    end
    if maininput:pressed("k4") then
      shuv.internal_rescale(shuv.internal_scale + 1)
    end
    if maininput:pressed("f5") then
      shuv.scale = shuv.scale + 1
      if shuv.scale > 7 then
        shuv.scale = 1
      end
      shuv.update = true
    end
  end

  if shuv.update then
    shuv.update = false
    if ismobile or project.fullscreen then
      love.window.setMode(0,0)
      love.window.setFullscreen(true)
      shuv.scale = love.graphics.getHeight() / project.res.y
      shuv.xoffset = love.graphics.getWidth()/2 - (project.res.x* shuv.scale) / 2
    else
      love.window.setMode(project.res.x*shuv.scale, project.res.y*shuv.scale)
    end
  end
end


function shuv.start()
  love.graphics.setColor(1, 1, 1, 1)
  love.graphics.setCanvas(shuv.canvas)
  love.graphics.setBlendMode("alpha")
end


function shuv.finish()
  love.graphics.setCanvas()
  love.graphics.draw(shuv.canvas,shuv.xoffset,shuv.yoffset,0,shuv.scale / shuv.internal_scale,shuv.scale / shuv.internal_scale)
  tinput = ""
  
  love.graphics.setCanvas(shuv.lastframe)
  love.graphics.draw(shuv.canvas,0,0)
  love.graphics.setCanvas()
end

return shuv