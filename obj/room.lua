Room = class('Room',Entity)

function Room:initialize(params)
  
  self.layer = 0 -- lower layers draw first
  self.uplayer = 0 --lower uplayer updates first
  
  
  Entity.initialize(self,params)

end


function Room:update(dt)
  
  
end

function Room:draw()
  color()
 
end

return Room