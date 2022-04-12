Thrownbox = class('Thrownbox',Entity)

function Thrownbox:initialize(params)
  
  self.layer = 12 -- lower layers draw first
  self.uplayer = 1 --lower uplayer updates first
  self.x = 0
  self.y = 0
  self.hp = 4
  self.name = 'Thrownbox'
  
  self.spr = ez.newanim(templates.block)
  
  self.hitbox = {x=0,y=0,width=8,height=8}
  
  Entity.initialize(self,params)

end





function Thrownbox:update(dt)
  
  
end

function Thrownbox:destroy()
  cs:addscore(100,'destroyedbox')
  self.delete = true
end




function Thrownbox:draw()
  color()
  ez.drawframe(self.spr,4-self.hp,self.x,self.y,0,1,1,5,5)
end

return Thrownbox