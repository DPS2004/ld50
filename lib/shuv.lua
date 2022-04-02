local shuv = {
  scale = 5,
  update = true,
  xoffset = 0,
  yoffset = 0
}


function shuv.init()
  shuv.canvas = love.graphics.newCanvas(project.res.x,project.res.y)
  shuv.scale = project.res.s
  
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


function shuv.check()
  if not ismobile then
    if maininput:pressed("f5") then
      shuv.scale = shuv.scale + 1
      if shuv.scale > 10 then
        shuv.scale = 1
      end
      shuv.update = true
    end
  end

  if shuv.update then
    shuv.update = false
    if ismobile then
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
  love.graphics.draw(shuv.canvas,shuv.xoffset,shuv.yoffset,0,shuv.scale,shuv.scale)
  tinput = ""
end

return shuv