Crusher = class('Crusher',Enemy)

function Crusher:initialize(params)
  
  
  
  Enemy.initialize(self,params)
  
  
  self.hp = 30
  
  self.hbsize = 12
  
  self.size = 10
  self.layer = 12
  
  self.sprite = sprites.crusher
  
  self.r = 0
  
  self.state = 0
  
  
  
  
end




function Crusher:update(dt)
  
  -- the hitbox size changes to make player colission more leniant, and wall colission less
  self.hbsize = 10
  self:bulletcheck(true)
  
  self.hbsize = 12
  self:move(dt)
  self:deathcheck()
  
  
  self.hbsize = 10
  
end

function Crusher:deathcheck()
  if self.hp <= 0 then
    self.delete = true
    
    cs.level = cs.level + 1
    
    em.init('enemypoof',{x=self.x,y=self.y,size=self.size,canv=self.canv})
    em.init('blackhole',{x=64,y=64,canv=self.canv})
    
    
    
    
  end
  
end

function Crusher:draw()
  love.graphics.push('all')
  for _,c in pairs(cs.cube.canvas) do
    love.graphics.setCanvas(c)
    self:drawt()
  end
  love.graphics.pop()
end

function Crusher:drawt()
  self:setshader()
  color()
  love.graphics.draw(self.sprite,self.x,self.y,math.rad(self.r),1,1,12,12)
  love.graphics.draw(sprites.bossface,self.x-5,self.y-2)
  self:endshader()
  
end

return Crusher