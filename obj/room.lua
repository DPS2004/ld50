Room = class('Room',Entity)

function Room:initialize(params)
  
  self.layer = 0 -- lower layers draw first
  self.uplayer = 0 --lower uplayer updates first
  self.wallcanvas = love.graphics.newCanvas(128,128)
  
  Entity.initialize(self,params)

end


function Room:update(dt)
  
  
end

function Room:draw()
  color()
  if not cs.map[cs.croom].cleared then
    love.graphics.draw(sprites.doors,0,0)
  end
  love.graphics.setCanvas(self.wallcanvas)
  love.graphics.clear()
  if self.level then
    color('red')
    for i,v in ipairs(self.level.tiles) do
      if v.t == 0 then
        love.graphics.rectangle('fill',v.x*8,v.y*8,8,8)
      end
    end
  end
  
  if self.canv then
    love.graphics.setCanvas(cs.cube.canvas[self.canv])
  else
    love.graphics.setCanvas(shuv.canvas)
  end
  color()
  love.graphics.setShader(wallshader)
  love.graphics.draw(self.wallcanvas,0,0)
  love.graphics.setShader()
  --love.graphics.print('test',1,1)
end

return Room