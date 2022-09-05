Hostdialog = class('Hostdialog',Entity)

function Hostdialog:initialize(params)
  
  self.layer = 0 -- lower layers draw first
  self.uplayer = 0 --lower uplayer updates first
  self.x = 230
  self.y = 40
  self.visible = true
  
  self.dialogid = 0
  
  self.currentbubble = nil
  
  self.spr = sprites.hostdialog
  
  Entity.initialize(self,params)

end

function Hostdialog:say(params)
  params = params or {}
  self.dialogid = self.dialogid + 1
  local cdialogid = self.dialogid
  local default = {
    text = "intro7",
    speed = -3,
    width = 200,
    height = 100,
    button = true,
    delay = 0,
    donext = nil,
    
    textcallback = nil,
    buttoncallback = nil,
    
    taildir = "left",
    tailoffset = 10,
    
    
  }
  for k,v in pairs(default) do
    if not params[k] then
      params[k] = v
    end
  end
  
  if self.currentbubble then
    self.currentbubble.delete = true
    self.currentbubble = nil
  end
  
  
  local skiptonext = function()
    if self.dialogid == cdialogid and self.currentbubble then
      
      self.currentbubble.delete = true
      self.currentbubble = nil
    
      
      if type(params.donext) == "table" then
        self:say(params.donext)
      elseif type(params.donext) == "function" then
        params.donext()
      end
      
      
    end
  end
  
  
  local bubbleparams = {
    x=256,
    y=62,
    width = params.width,
    height = params.height,
    text = params.text,
    
    taildir = params.taildir,
    tailoffset = params.tailoffset,
    
    showbutton = params.button
    
  }
  
  if params.button then
    bubbleparams.textcallback = function()
      if params.textcallback then
        params.textcallback()
      end
    end
    bubbleparams.buttoncallback = function()
      if params.buttoncallback then
        params.buttoncallback()
      end
      skiptonext()
    end
  else
    bubbleparams.textcallback = function()
      if params.textcallback then
        params.textcallback()
      end
      skiptonext()
    end
  end
  
  self.currentbubble = em.init('speechbubble',bubbleparams)
  
  return skiptonext
end

function Hostdialog:update(dt)
  prof.push("hostdialog update")
  
  prof.pop("hostdialog update")
end

function Hostdialog:draw()
  prof.push("hostdialog draw")
  if self.visible then
    color('white')
    love.graphics.draw(self.spr,self.x,self.y)
  end
  prof.pop("hostdialog draw")
end

return Hostdialog