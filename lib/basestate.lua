local basestate = {state = "title", states = {}} -- fuck

function basestate.get()
  return basestate.state
end


function basestate.new(name)
  basestate.states[name] = love.filesystem.load("states/" .. name .. ".lua") -- this is a bad idea  
  print("made state ".. name)
end

function basestate.load(name)
  return basestate.states[name]()
end




return basestate