dpf = {}


function dpf.loadjson(f,w)
  w = w or {}
  print("dpf loading "..f)
  local cf = love.filesystem.read(f)
  if cf == nil then
    local newdir = helpers.rliid(f)
    if newdir ~= "" then
      while true do
        if love.filesystem.createDirectory(helpers.rliid(newdir)) then
          print("created " .. newdir)
          if newdir == f then
            
            break
          else
            newdir = f
          end
        else
          print("failed to create " .. newdir)
          newdir = helpers.rliid(newdir)
          
        end        
      end
    end
    love.filesystem.createDirectory(helpers.rliid(f))
    print("trying to write a file cause it didnt exist")
    print(love.filesystem.write(f,json.encode(w)))
    cf = json.encode(w)
  end
  return json.decode(cf)
end

function dpf.savejson(f,w)
      local newdir = helpers.rliid(f)
    if newdir ~= "" then
      while true do
        if love.filesystem.createDirectory(helpers.rliid(newdir)) then
          print("created " .. newdir)
          if newdir == f then
            
            break
          else
            newdir = f
          end
        else
          print("failed to create " .. newdir)
          newdir = helpers.rliid(newdir)
          
        end        
      end
    end
    love.filesystem.createDirectory(helpers.rliid(f))
  love.filesystem.write(f,json.encode(w))
end


return dpf