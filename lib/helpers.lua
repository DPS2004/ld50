local helpers = {}


function helpers.collide( a, b )
   local overlap = false
   if not( a.x + a.width < b.x  or b.x + b.width < a.x  or
           a.y + a.height < b.y or b.y + b.height < a.y ) then
      overlap = true
   end
   return overlap
end


function helpers.rotate(rad, angle, x, y)
  return({
    (rad * math.cos((90 - angle) * math.pi / 180))+x,
    (0 - rad * math.sin((90 - angle) * math.pi / 180))+y
  })
end


function helpers.color(c)
  love.graphics.setColor(colors[c])
end


function helpers.read(path)
  local content = love.filesystem.read(path) -- r read mode and b binary mode
  return content
end


function helpers.write(path, data)
  love.filesystem.write(path,data)
end


function helpers.round(i,fb)
  fb = fb or true
  if i % 1 > 0.5 then
    return math.ceil(i)
  elseif i % 1 < 0.5 then
    return math.floor(i)
  elseif fb then
    return math.floor(i)
  else
    return i
  end
end


function helpers.distance(p,q)
  return(math.sqrt(((q[1])-(p[1]))^2+((q[2])-(p[2]))^2))
end


function helpers.angdistance(x,y)
  return 180 - math.abs(math.abs((x%360) - (y%360)) - 180)
end


function helpers.swap(tsw)
  toswap = tsw
  newswap = true
end


function helpers.updatemouse()
  if not mouse then mouse = {x = 0, y = 0, pressed = 0,altpress=0} end
  if mouse.pressed == -1 then
    mouse.pressed = 0
  end
  if love.mouse.isDown(1) then
    mouse.pressed = mouse.pressed + 1
  elseif mouse.pressed >=1 then
    mouse.pressed = -1
  else
    mouse.pressed = 0
  end
  
  
  if mouse.altpress == -1 then
    mouse.altpress = 0
  end
  if love.mouse.isDown(2) then
    mouse.altpress = mouse.altpress + 1
  elseif mouse.altpress >=1 then
    mouse.altpress = -1
  else
    mouse.altpress = 0
  end
  
  mouse.x = helpers.round(((love.mouse.getX()/love.graphics.getWidth())*160),true)
  mouse.y = helpers.round(((love.mouse.getY()/love.graphics.getHeight())*90),true)
end


function helpers.clamp(val, lower, upper)
  if lower > upper then lower, upper = upper, lower end
  return math.max(lower, math.min(upper, val))
end


function helpers.lerp(a, b, t)
  return a + (b - a) * t
end

helpers.eases = {
  ["Linear"] = function (t)
    return t
  end,

  ["InQuad"] = function (t)
    return math.pow(t, 2)
  end,

  ["OutQuad"] = function (t)
    return 1 - math.pow(1 - t, 2)
  end,
  
  ["InOutQuad"] = function (t)
    return t<0.5 and math.pow(t, 2)*2 or 1 - math.pow(1 - t, 2)*2
  end,
  
  ["OutInQuad"] = function (t)
    return t<0.5 and 0.5-math.pow(0.5-t, 2)*2 or 0.5+math.pow(0.5-t, 2)*2
  end,

  ["InCubic"] = function (t)
    return math.pow(t, 3)
  end,

  ["OutCubic"] = function (t)
    return 1 - math.pow(1 - t, 3)
  end,
  
  ["InOutCubic"] = function (t)
    return t<0.5 and math.pow(t, 3)*4 or 1 - math.pow(1 - t, 3)*4
  end,

  ["InQuart"] = function (t)
    return math.pow(t, 4)
  end,

  ["OutQuart"] = function (t)
    return 1 - math.pow(1 - t, 4)
  end,
  
  ["InOutQuart"] = function (t)
    return t<0.5 and math.pow(t, 4)*8 or 1 - math.pow(1 - t, 4)*8
  end,

  ["InQuint"] = function (t)
    return math.pow(t, 5)
  end,

  ["OutQuint"] = function (t)
    return 1 - math.pow(1 - t, 5)
  end,
  
  ["InOutQuint"] = function (t)
    return t<0.5 and math.pow(t, 5)*16 or 1 - math.pow(1 - t, 5)*16
  end,

  ["InExpo"] = function (t)
    return math.pow(2, (10 * (t - 1)))
  end,

  ["OutExpo"] = function (t)
    return 1 - math.pow(2, (10 * (-t)))
  end,
  
  ["InSine"] = function (t)
    return 1 - math.cos(t * (math.pi * .5))
  end,

  ["OutSine"] = function (t)
    return math.cos((1 - t) * (math.pi * .5))
  end,

  ["InOutSine"] = function (t)
    return (math.cos((t+1)*math.pi)*0.5)+0.5
  end,

  ["InCirc"] = function (t)
    return 1 - math.sqrt(1 - (math.pow(t, 2)))
  end,

  ["OutCirc"] = function (t)
    return math.sqrt(1 - (math.pow(1 - t, 2)))
  end,

  ["InBack"] = function (t)
    return math.pow(t, 2) * (2.7 * t - 1.7)
  end,

  ["OutBack"] = function (t)
    return 1 - math.pow(1 - t, 2) * (2.7 * (1 - t) - 1.7)
  end,

  ["InElastic"] = function (t)
    return -(2^(10 * (t - 1)) * math.sin((t - 1.075) * (math.pi * 2) / .3))
  end,

  ["OutElastic"] = function (t)
    return 1 + (2^(10 * (-t)) * math.sin(((1 - t) - 1.075) * (math.pi * 2) / .3))
  end,
  
  -- doing that was a pain - moplo
}

function helpers.interpolate(a, b, t, ease)
  local q
  if helpers.eases[ease] then
    q = helpers.eases[ease] (t)
  else
    q = helpers.eases["Linear"] (t)
  end

  return helpers.lerp (a, b, q)
end

function helpers.anglepoints(x,y,a,b)
  return math.deg(math.atan2(x-a,y-b))*-1
end

function helpers.trim(s)
  return s:match "^%s*(.-)%s*$"
end

function helpers.rliid(fname)

  local fname2 = ""
  local offset = 0
  if string.sub(fname,-1) == "/" then
    fname = string.sub(fname,1,-2)
  end
  fname2 = fname:match(".*/(.*)")
  if fname2 then
    fname = string.sub(fname,1,-(string.len(fname2)+1))
    return fname
  else
    return ""
  end
end

function helpers.isanglebetween(a1,a2,a3)
  --make a1 and a2 positive
  while a1 < 0 or a2 < 0 do
    a1 = a1 + 360
    a2 = a2 + 360
  end
  --make sure either a1 or a2 are below 360 degrees
  while a1 > 360 and a2 > 360 do
    a1 = a1 - 360
    a2 = a2 - 360
  end
  --if the distance between a1 and a2 is 360+ degrees, a3 will always be between the two no matter what
  if math.abs(a2-a1) >= 360 then
    return true
  end
  --make sure a2 is greater than a1 (such that if one of the two are over 360 degrees, it'll be a2)
  if a1 > a2 then
    a1, a2 = a2, a1
  end
  --i dont even know how to explain this, but basically this offsets everything to turn the situation into another one with an identical answer where a1 and a2 are both between 0 and 360
  if a2 > 360 then
    a1 = a1 - a2 + 360
    a3 = a3 - a2 + 360
    a2 = 360
  end
  --make sure a3 is between 0 and 360
  a3 = a3 % 360
  --finally determine if a3 is between a1 and a2
  if a2 > a3 and a3 > a1 then
    return true
  else
    return false
  end
end
--check if cursor is inside of (or on) a rectangle (x1 is left, x2 is right, y1 is top, y2 is bottom)
function helpers.inrect(x1,x2,y1,y2,cursorx,cursory)
  if x2 >= cursorx and cursorx >= x1 and y2 >= cursory and cursory >= y1 then
    return true
  else
    return false
  end
end
--check if cursor is inside of (or on) an ellipse
function helpers.iscursorinellipse(x1,x2,y1,y2,cursorx,cursory)
end

function helpers.copy(t)
  local t2 = {}
  for k,v in pairs(t) do
    t2[k] = v
  end
  return t2

end

function helpers.drawbordered(df,bcol,lightborder)
  bcol = bcol or 'black'
  if bcol == 'black' then
    love.graphics.setColor({0,0,0,1})
  else
    love.graphics.setShader(whiteoutshader)
  end
  
  for x=-1,1 do
    for y=-1,1 do
      if not (x== 0 and y == 0) then
        if (not lightborder) or (x == 0 or y == 0) then
          df(x,y)
        end
      end
    end
  end
  
  love.graphics.setColor({1,1,1,1})
  if bcol == 'white' then
    love.graphics.setShader()
  end
  df(0,0)

end

return helpers