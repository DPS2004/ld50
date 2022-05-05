local st = Gamestate:new('editor_mapselect')

st:setinit(function(self)
  --em.init('templateobj',{x=128,y=72})
  self.typing = false
  self.typefinish = 'none'
  self.textin = ''
  
  
  
  if not savedata.properties then
    savedata.properties = {}
    savedata.properties.version = 0
  end
  
  
  --backwards compat with old versions of the format
  
  if savedata.properties.version == 0 then
    print('updating map format to version 1')
    local newlevels = {}
    newlevels.properties = {version = 1}
    newlevels.groups = {}
    for groupname, group in pairs(savedata.groups) do
      newlevels.groups[groupname] = {}
      for i,v in ipairs(group) do --move all level tile data to separate tile table
        table.insert(newlevels.groups[groupname],
          {
            width = 16,
            height = 16,
            tiles = helpers.copy(v)
          }
        )
      end
    end
    
    savedata = newlevels
    sdfunc.save()    
  end
  
  
  if savedata.properties.version == 1 then
    print('updating map format to version 2')
    local newlevels = {}
    newlevels.properties = {
      version = 2,
      halfsize = {0,3},
      tilesize = 4
    }
    newlevels.groups = {}
    for groupname, group in pairs(savedata.groups) do
      newlevels.groups[groupname] = {}
      for i,v in ipairs(group) do --move all level tile data to separate tile table
        local newtiles = {}
        local newroom = {
          width = 32,
          height = 32,
          tiles = helpers.copy(v.tiles)
        }
        for i,v in ipairs(newroom.tiles) do
          v.x = v.x * 2
          v.y = v.y * 2
          if helpers.tablematch(v.t,newlevels.properties.halfsize) then
            table.insert(newtiles,{x=v.x+1,y=v.y+0,t=v.t})
            table.insert(newtiles,{x=v.x+0,y=v.y+1,t=v.t})
            table.insert(newtiles,{x=v.x+1,y=v.y+1,t=v.t})
          else
            v.x = v.x + 1
            v.y = v.y + 1
          end
          
          if helpers.tablematch(v.t,{15,22,23,32}) then
            --tutorial portal, bubble, tutorial target, and spinner boss
            v.x = v.x + 1
            v.y = v.y + 1
          end
        end
        
        for i,v in ipairs(newtiles) do
          table.insert(newroom.tiles,v)
        end
          
        table.insert(newlevels.groups[groupname],
          newroom
        )
      end
    end
    
    savedata = newlevels
    sdfunc.save()    
  end
  
  
  
end)


st:setupdate(function(self,dt)
  if not self.typing then
    if maininput:down('ctrl') and maininput:pressed('n') then
      self.typing = true
      self.typefinish = 'new'
      self.textin = ''
      print('ctrl n')
    elseif maininput:down('ctrl') and maininput:pressed('l') then
      self.typing = true
      self.typefinish = 'load'
      self.textin = ''
      print('ctrl l')
    end
  end
  
  if self.typing then
    
    if maininput:pressed('accept') then
      self.typing = false
      if self.typefinish == 'new' then
        savedata.groups[self.textin] = {}        
      end
      if self.typefinish == 'load' then
        if savedata.groups[self.textin] then
          cs = bs.load('editor')
          cs:init()
          cs.mapgroup = self.textin
          cs:setuplevel()
        else
          print('that doesnt exist!')
        end
      end
      
      sdfunc.save()
      
    else
      if tinput then
        self.textin = self.textin .. tinput
      end
      if maininput:pressed('backspace') then
        self.textin = ''
      end
      
    end
  end
  
end)

st:setbgdraw(function(self)
  color('black')
  love.graphics.rectangle('fill',0,0,project.res.x,project.res.y)
end)
--entities are drawn here
st:setfgdraw(function(self)
  
  color('red')
  love.graphics.print(self.textin or '',1,1)
  color()
  local grouplist = ''
  for k,v in pairs(savedata.groups) do
    grouplist = grouplist .. k .. ': '..#v..'\n'
  end
  love.graphics.print(grouplist,1,10)
end)

return st