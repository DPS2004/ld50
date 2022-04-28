Crusher = class('Crusher',Enemy)

function Crusher:initialize(params)
  
  
  
  Enemy.initialize(self,params)
  
  
  self.hp = 60
  
  self.hbsize = 11
  
  self.size = 10
  self.layer = 12
  
  self.sprite = sprites.crusher
  
  self.r = 0
  
  self.state = 0
  self.statetimer = 50
  self.endingstate = false
  
  self.shakecharge = 0
  
  rw:func(1,function()
    self:changestate(1)
  end)
  rw:play()
  
  
end


function Crusher:changestate(forced)
  
  self.statetimer = math.random(300,500)
  
  local numstates = 3
  
  self.state = (((self.state - 1) + math.random(1,numstates -1))%(numstates))+1
  if forced then
    self.state = forced
  end
  
  
  if self.state == 1 then
    self.statetimer = 9999
    print('running state 1')
    
    self.shakecharge = 0
    self.chargeangle = helpers.anglepoints(self.x,self.y,cs.player.x,cs.player.y - 3)
    local ang = helpers.rotate(3,self.chargeangle,0,0)
    self.chargex = ang[1]
    self.chargey = ang[2]
    rw:ease(0,2,'linear',0.15,self,'shakecharge')
    rw:func(2,function()
      self.shakecharge = 0
      self.dx = self.chargex
      self.dy = self.chargey
    end)
    rw:play({bpm = math.random(40,80)})
    
  elseif self.state == 2 then
    self.statetimer = 499
    print('running state 2')
    
  
  elseif self.state == 3 then
    self.statetimer = 499
    print('running state 3')
    
  end
  self.endingstate = false
end


function Crusher:update(dt)
  
  if self.state ~= 0 then
    self.statetimer = self.statetimer - dt
  end
  if self.statetimer <= 0 and self.state ~= 0 and self.endingstate == false then
    self.endingstate = true
    
    --end of each state
    if self.state == 1 then
      print('ending state 1')
      
      self:changestate()
    elseif self.state == 2 then
      print('ending state 2')
      
      self:changestate()
    elseif self.state == 3 then
      print('ending state 3')
      
      self:changestate()
    end
  end
  
  
  
  
  
  -- the hitbox size changes to make player colission more leniant, and wall colission less
  self.hbsize = 10
  self:bulletcheck(true)
  
  self.hbsize = 11
  
  local hit = self:move(dt)
  if hit and self.state == 1 then
    print('hit wall')
    self.dx = 0
    self.dy = 0
    self.shakecharge = 0.15
    
    local ang1 = helpers.rotate(3,self.chargeangle+150,0,0)
    local ang2 = helpers.rotate(3,self.chargeangle-150,0,0)
    
    em.init('enemybullet',{x=self.x, y=self.y,
      dx=ang1[1],dy=ang1[2],
      hbsize = 3,
      size = 4,
      canv=self.canv,
      all_canv = true
    })
    em.init('enemybullet',{x=self.x, y=self.y,
      dx=ang2[1],dy=ang2[2],
      hbsize = 3,
      size = 4,
      canv=self.canv,
      all_canv = true
    })
  
    rw:ease(0,1,'linear',0,self,'shakecharge')
    rw:func(1,function()
      self:changestate()
    end)
    rw:play()
  end
  
  
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
  love.graphics.draw(self.sprite,self.x+(math.random(-10,10)*self.shakecharge),self.y+(math.random(-6,6)*self.shakecharge),math.rad(self.r),1,1,12,12)
  love.graphics.draw(sprites.bossface,self.x+(math.random(-10,10)*self.shakecharge)-5,self.y-2)
  self:endshader()
  
end

return Crusher