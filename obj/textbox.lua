Textbox = class('Textbox',Entity)

function Textbox:initialize(params)
  self.x = 10
  self.y = 10
  self.width = 140
  self.height = 70
  
  self.layer = 111
  self.uplayer = 3
  
  self.font = fonts.disco
  self.lineshrink = 2
  
  self.progress = 0
  
  self.length = 200
  
  self.color = colors.black
  
  self.text = 'A wizard\'s job is\nto &vex& chumps ^quiickly^ in fogs. &Interesting,& right?'
  --self.text = 'abcdefghijklmnopqrstuvqxyz'
  self.sound = 'assets/sfx/text.ogg'
  
  Entity.initialize(self,params)
  
  self.totalchars = string.len(self.text)
  self.cprogress = self.progress + 1
  self.lastcprogress = 0
  if self.length == 0 then
    self.sound = nil
    self.progress = 1
  else
    local talkease = rw:to(self, self.length, {progress = 1}):ease('linear')
    if self.callback then
      talkease:oncomplete(self.callback)
    end
  end
  
  
  
  -- get rid of control characters
  local removedoffset = 0
  local fulltext = ''
  self.letters = {}
  local effects = {}
  effects['^'] = false
  effects['&'] = false
  
  for i=1,self.totalchars do
    local cc = string.sub(self.text,i,i)
    
    if cc == '^' or cc == '&' then
      removedoffset = removedoffset + 1
      effects[cc] = not effects[cc]
    else
      
      --print(cc,i-removedoffset)
      self.letters[i-removedoffset] = {
        txt = {{0,0,0,0},fulltext,{1,1,1,1},cc},
        line = 0
      }
      fulltext = fulltext .. cc
      for k,v in pairs(effects) do
        self.letters[i-removedoffset][k] = v
      end
    end
  end
  
  self.text = fulltext
  self.totalchars = self.totalchars - removedoffset
  
  
  --error()
  --replace word wrapping with newlines
  for i=1,self.totalchars do
    local ctext = string.sub(self.text,1, i)
    if self.font:getWidth(ctext) > self.width then
      local nlpos = i
      while true do
        local cc = string.sub(self.text,nlpos,nlpos)
        if cc ~= helpers.trim(cc) then
          break
        end
        nlpos = nlpos - 1
      end
      self.text = string.sub(ctext,1,nlpos-1) .. '\n' .. string.sub(self.text,nlpos+1)
      for li,lv in ipairs(self.letters) do
        if li > nlpos then
          self.letters[li].line = self.letters[li].line + 1
          local ogstr = self.letters[li].txt[2]
          self.letters[li].txt[2] = string.sub(ogstr,1,nlpos-1).. '\n' .. string.sub(ogstr,nlpos+1)
        end
      end
    end
  end
  
  
  self.siner = 0
end


function Textbox:update(dt)
  
  --
  self.cprogress = math.floor((self.totalchars-1)*self.progress)+1
  
  
    
  if self.cprogress > self.lastcprogress then
    local cc = string.sub(self.text,self.cprogress,self.cprogress)
    if self.sound then
      if cc == helpers.trim(cc) then
        --te.stop('textbox')
        te.play(self.sound,'static',{'textbox','sfx'},0.2)
      end
    end
  end
  
  
  self.lastcprogress = self.cprogress
  
  self.siner = (self.siner + dt/20)%(math.pi *2)
  
end

function Textbox:draw(dx,dy)
  self.x = dx
  self.y = dy
  local function shake(x)
    return helpers.round(math.random(-100,100)*(x/100),true)
  end
  love.graphics.setFont(self.font)
  --love.graphics.setColor(colors.red)
  --love.graphics.setLineWidth(1)
  --love.graphics.rectangle('line',self.x,self.y,self.width,self.height)
  
  love.graphics.setColor(self.color)
  --love.graphics.printf(self.ctext,self.x,self.y,self.width)
  for i=1,self.cprogress do
    local cl = self.letters[i]
    if cl['^'] then
      
      love.graphics.printf(cl.txt,self.x,self.y+math.sin(self.siner+i)*2-cl.line*self.lineshrink,self.width)
    elseif cl['&'] then
      love.graphics.printf(cl.txt,self.x+shake(0.55),self.y+shake(0.55)-cl.line*self.lineshrink,self.width)
    else
      love.graphics.printf(cl.txt,self.x,self.y-cl.line*self.lineshrink,self.width)
    end
  end
end

return Textbox