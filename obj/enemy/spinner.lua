Spinner = class('Spinner',Enemy)

function Spinner:initialize(params)
  
  self.orbiternum = 4
  
  if cs.level ~= 0 then
    self.orbiternum = math.min(4+cs.level,10)
  end
  params.hbsize = params.hbsize or 4
  
  Enemy.initialize(self,params)
  
  self.pulsei = 0
  self.angle = 0
  
  self.extend = 0
  
  self.hp = 30
  
  self.size = 8
  self.layer = 12
  
  self.shotcooldown = 0
  
  self.rotatespeed = 0
  
  
  
  self.state = 0
  self.statetimer = 9999
  self.endingstate = false
  
  self.orbiters = {}
  
  for i=1,self.orbiternum do
    table.insert(self.orbiters,em.init('spinner_orbiter',{x=self.x,y=self.y,parentspinner=self,canv=self.canv}))
  end
  
  
  
  rw:ease(0,1,'outExpo',14,self,'extend')
  rw:ease(0,1,'linear',6,self,'rotatespeed')
  rw:func(1,function() self:changestate(1) end)
    
  rw:play()
  
end


function Spinner:changestate(forced)
  
  print('changing state')
  self.statetimer = math.random(300,500)
  
  local numstates = 3
  
  self.state = (((self.state - 1) + math.random(1,numstates -1))%(numstates))+1
  if forced then
    self.state = forced
  end
  
  --self.state = 2
  if #self.orbiters == 0 then
    self.state = 1
  end
  
  if self.state == 1 then
    self.chargespeed = 0.25
    rw:ease(0,1,'linear',6,self,'rotatespeed')
    rw:ease(0,4,'linear',0.75,self,'chargespeed')
    rw:play()
  elseif self.state == 2 then
    self.statetimer = 499
    local dir = math.random(0,1)*3-1.5
    rw:ease(0,0.5,'linear',dir,self,'rotatespeed')
    rw:play()
  
  elseif self.state == 3 then
    self.statetimer = 9999
    rw:ease(0,1,'inOutSine',64,self,'x')
    rw:ease(0,1,'inOutSine',64,self,'y')
    rw:ease(0,5,'linear',10,self,'rotatespeed')
    rw:ease(1,2,'outSine',50,self,'extend')
    rw:ease(3,2,'inSine',14,self,'extend')
    rw:func(5,function() self.statetimer = 0 self:changestate() end)
    rw:play()
  end
  self.endingstate = false
end

function Spinner:update(dt)
  
  
  if self.shotcooldown > 0 then
    self.shotcooldown = self.shotcooldown - dt
  else
    self.shotcooldown = 0
  end
  
  if self.state ~= 0 then
    self.statetimer = self.statetimer - dt
  end
  if self.statetimer <= 0 and self.state ~= 0 and self.endingstate == false then
    self.endingstate = true
    
    --end of each state
    if self.state == 1 then
      print('ending state 1')
      rw:ease(0,1,'linear',0,self,'dx')
      rw:ease(0,1,'linear',0,self,'dy')
      rw:func(1,function() self:changestate() end)
      rw:play()
    elseif self.state == 2 then
      print('ending state 2')
      rw:ease(0,1,'linear',0,self,'rotatespeed')
      rw:func(1,function() self:changestate() end)
      rw:play()
    end
  end
  
  
  if self.state == 1 then
    if not self.endingstate then
      local ang = helpers.rotate(0.5,helpers.anglepoints(self.x,self.y,cs.player.x,cs.player.y - 3),0,0)
      self.dx = ang[1]
      self.dy = ang[2]
    end
  end
  
  
  self.pulsei = self.pulsei + dt/20
  self.angle = self.angle + dt*self.rotatespeed
  local fired = false
  for i,v in ipairs(self.orbiters) do
    local ang = helpers.rotate(self.extend,(i-0)*(360/self.orbiternum)+ self.angle,0,0)
    v.x = ang[1] + self.x
    v.y = ang[2] + self.y
    v:update(dt)
    if v.delete then
      table.remove(self.orbiters,i)
    else
      if self.state == 2 then
        if self.shotcooldown == 0 then
          if math.floor(self.statetimer/50)%2 == 0 then
            fired = true
            em.init('enemybullet',{x=v.x,y=v.y,dx=ang[1]/10,dy=ang[2]/10,canv=self.canv,all_canv = true})
          end
        end
      end
    end
  end
  
  if fired then
    self.shotcooldown = 6
    te.play('assets/sfx/enemy_fire.ogg','static',{'enemy_fire','sfx'},0.5)
  end
  self:bulletcheck()
  self:move(dt)
  self:deathcheck()
  
end

function Spinner:deathcheck()
  if self.hp <= 0 then
    self.delete = true
    for i,v in ipairs(self.orbiters) do
      v.delete = true
    end
    cs.level = cs.level + 1
    
    em.init('enemypoof',{x=self.x,y=self.y,size=self.size,canv=self.canv})
    em.init('blackhole',{x=64,y=64,canv=self.canv})
    
    
    
    
  end
  
end

function Spinner:draw()
  love.graphics.push('all')
  for _,c in pairs(cs.cube.canvas) do
    love.graphics.setCanvas(c)
    self:drawt()
  end
  love.graphics.pop()
end

function Spinner:drawt()
  for i,v in ipairs(self.orbiters) do
    v:draw()
  end
  self:setshader()
  love.graphics.setColor(1,58/255,153/255,1)
  love.graphics.circle('fill',self.x,self.y,self.size+math.sin(self.pulsei))
  color()
  love.graphics.draw(sprites.bossface,self.x-5,self.y-2)
  self:endshader()
  
end

return Spinner