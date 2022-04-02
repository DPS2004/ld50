local em = {
  deep = deeper.init(),
  entities = {}
}


function em.new(fname,name)
  em.entities[name] = love.filesystem.load(fname)() -- this is a bad idea  
  print("made entity ".. name .." from " ..fname)
end

function em.init(en,kvtable)
  local succ, new = pcall(function() return em.entities[en]:new(kvtable) end)
  if not succ then
    print(new)
    error('tried to init entity named ' .. en ..', which did not exist')
  end

--  for k,v in pairs(kvtable) do
--    new[k] = v
--  end
--  new.name = en
  table.insert(entities,new)

  return entities[#entities]
end


function em.update(dt)
  
  
  for i,v in ipairs(entities) do
    if not paused then
      em.deep.queue(v.uplayer, em.update2, v, dt)
    elseif v.runonpause then
      em.deep.queue(v.uplayer, em.update2, v, dt)
    end
  end
  em.deep.execute() -- OH MY FUCKING GOD IM SUCH A DINGUS
end


function em.draw()
  
  for i, v in ipairs(entities) do
    if not v.skiprender then

      em.deep.queue(v.layer, function() 
        if v.canv then
          love.graphics.setCanvas(cs.cube.canvas[v.canv])
        else
          love.graphics.setCanvas(shuv.canvas)
        end
        v:draw() 
      end)
      
    end
  end
  em.deep.execute()
  for i,v in ipairs(entities) do
    if v.delete then
      table.remove(entities, i)
    end
  end
end


function em.update2(v,dt)
  v:update(dt)
end


return em