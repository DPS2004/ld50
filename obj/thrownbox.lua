Thrownbox = class('Thrownbox',Entity)

function Thrownbox:initialize(params)
  
  self.layer = 12 -- lower layers draw first
  self.uplayer = 1 --lower uplayer updates first
  self.x = 0
  self.y = 0
  self.dx = 0
  self.dy = 0
  self.hp = 4
  self.name = 'thrownbox'
  
  self.spr = ez.newanim(templates.block)
  
  self.hitbox = {x=0,y=0,width=8,height=8}
  
  self.ishit = false
  
  self.hitobjs = {}
  
  Entity.initialize(self,params)

end





function Thrownbox:update(dt)
  self.hitbox.x = self.x - 5
  self.hitbox.y = self.y - 5
end

function Thrownbox:destroy()
  cs:addscore(100,'destroyedbox')
  self.delete = true
end

function Thrownbox:checkhit(o)
  for i,v in ipairs(self.hitobjs) do
    if v == o then
      return false
    end
  end
  return true
end

function Thrownbox:gethit(o)
  self.ishit = true
  table.insert(self.hitobjs,o)
  self.hp = self.hp - 1
  if self.hp == 0 then
    self:destroy()
  end
end


function Thrownbox:draw()
  if self.ishit then
    love.graphics.setShader(shaders.whiteout)
  end
  color()
  ez.drawframe(self.spr,4-self.hp,self.x,self.y,0,1,1,5,5)
  if self.ishit then
    love.graphics.setShader()
    self.ishit = false
  end
end

return Thrownbox