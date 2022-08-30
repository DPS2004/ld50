Room = class('Room',Entity)

function Room:initialize(params)
  
  self.layer = 0 -- lower layers draw first
  self.uplayer = 0 --lower uplayer updates first
  self.wallcanvas = love.graphics.newCanvas(128,128)
  
  Entity.initialize(self,params)
  
  self.blockspr = ez.newanim(templates.block)

end


function Room:update(dt)
  
end

function Room:drawwalls(tilecheck)
  
  tilecheck = tilecheck or {0,5}
  
  love.graphics.setCanvas(self.wallcanvas)
  love.graphics.clear()
  if self.level then
    color('red')
    for i,v in ipairs(self.level.tiles) do
      if helpers.tablematch(v.t,tilecheck) then
        love.graphics.rectangle('fill',v.x*levels.properties.tilesize,v.y*levels.properties.tilesize,levels.properties.tilesize,levels.properties.tilesize)
      end
    end
  end
  
  if self.canv then
    love.graphics.setCanvas(cs.cube.canvas[self.canv])
  else
    love.graphics.setCanvas(shuv.canvas)
  end
  color()
  love.graphics.setShader(shaders.walls)
  love.graphics.draw(self.wallcanvas,0,0)
  love.graphics.setShader()
  
end

function Room:draw()
  prof.push("room draw")
  color()
  if not cs.map[cs.croom].cleared then
    self:drawwalls({4})
  end
  
  
  
  self:drawwalls()
  
  
  
  if self.level then
    color('white')
    for i,v in ipairs(self.level.tiles) do
      if v.t == 2 then
        if v.drawflash then
          love.graphics.setShader(shaders.whiteout)
        end
        ez.drawframe(self.blockspr,4-v.hp,v.x*levels.properties.tilesize-5,v.y*levels.properties.tilesize-5)
        if v.drawflash then
          love.graphics.setShader()
          v.drawflash = false
        end
      end
    end
  end
  
  if cs.map[cs.croom].cleared and cs.pointsgained == 0 and cs.player.canmove and (not cs.playtutorial) then
    love.graphics.draw(sprites.instructions,0,0)
  end
  if self.level and self.level.tutorialsecret then
    cs.secretary:draw(true)
  end
  prof.pop("room draw")
  --love.graphics.print('test',1,1)
end

return Room