local ezanim = {}
-- ez.newtemplate(path to image file,width,frames per advance,loops(boolean), border size(0 by default))
function ezanim.newtemplate(png,w,s,l,b,h,frames)
  local t = {}
  t.w = w
  t.s = s
  t.b = b or 0
  if l == nil then
    t.l = true
  else
    t.l = l
  end
  t.name = png
  t.img = love.graphics.newImage("assets/" .. png)
  t.h = h or t.img:getHeight()
  t.frames = frames or t.img:getWidth()/(w+t.b)
  t.quads = {}
  local offset = 0
  for i=0,t.frames - 1 do
    
    quad = love.graphics.newQuad((i * t.w + offset)%t.img:getWidth(), math.floor((i * t.w + offset)/t.img:getWidth())*t.h , t.w, t.h, t.img:getWidth(), t.img:getHeight())
    table.insert(t.quads, quad)
    offset = offset + t.b
  end
  t.type = "normal"
  return t
end

function ezanim.newanim(temp)
  local a = {}
  a.temp = temp
  a.f = 1
  a.time = 0
  return a
end

function ezanim.update(a,indt)
  indt = indt or dt
  a.time = a.time + indt
  if a.temp.s ~= 0 then
    if a.time >= a.temp.s then
      framesmissed = math.floor(a.time / a.temp.s)
      a.f = a.f + framesmissed
      a.time = a.time - framesmissed * a.temp.s
      
    end
    while a.f >= a.temp.frames + 1 do
      if a.temp.l then
        a.f = a.f - a.temp.frames
      else
        a.f = a.temp.frames
      end
    end 
  else
  end
end

function ezanim.rframe(a)

  a.f = math.random(1,a.temp.frames)

end

function ezanim.draw(a,x,y,r,sx,sy,ox,oy,kx,ky)
  x = x or 0
  y = y or 0
  r = r or 0
  sx = sx or 1
  sy = sy or sx
  ox = ox or 0
  oy = oy or 0
  kx = kx or 0
  ky = ky or 0
  quad = a.temp.quads[a.f]
  if a.temp.type == "4color" then
    for i=1,4 do
      love.graphics.setColor(colors[i])
      love.graphics.draw(a.temp.img[i],quad,x,y,r,sx,sy,ox,oy,kx,ky)
    end
  else
--    if debugprint and a.temp.name == "player/grabdrill.png" then
--      print("drawing frame " .. a.f .. " of " .. a.temp.name .. " of total frames " .. a.temp.frames)
--      print(quad:getViewport())
--    end
    
    love.graphics.draw(a.temp.img,quad,x,y,r,sx,sy,ox,oy,kx,ky)
    
  end
end


function ezanim.drawframe(a,f,x,y,r,sx,sy,ox,oy,kx,ky)
  f = f or 0
  x = x or 0
  y = y or 0
  r = r or 0
  sx = sx or 1
  sy = sy or sx
  ox = ox or 0
  oy = oy or 0
  kx = kx or 0
  ky = ky or 0
  quad = a.temp.quads[f+1]
  if a.temp.type == "4color" then

  else
    
    love.graphics.draw(a.temp.img,quad,x,y,r,sx,sy,ox,oy,kx,ky)
    
  end
end

function ezanim.reset(a)
  a.f=1
  a.time=0
end
return ezanim