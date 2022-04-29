Crusher = class('Crusher',Enemy)

function Crusher:initialize(params)
  
  
  
  Enemy.initialize(self,params)
  
  
  self.hp = 80
  
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
  
  --self.statetimer = math.random(300,500)
  
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
    local ang = helpers.rotate(4,self.chargeangle,0,0)
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
    self.statetimer = math.random(500,800)
    print('running state 2')
    self:cardinalcharge()
  
  elseif self.state == 3 then
    self.statetimer = 9999
    print('running state 3')
    self:spin(20)
    
  end
  self.endingstate = false
end

function Crusher:spin(spinsleft)
  spinsleft = spinsleft - 1
  self.r = 0
  rw:ease(0,1,'inQuad',90,self,'r')
  rw:func(1,function()
    self.r = 0
    te.play('assets/sfx/enemy_fire.ogg','static',{'enemy_fire','sfx'},0.5)
    local bullnum = 0
    if cs.level == 0 then
      bullnum = math.random(1,2)
    else
      bullnum = math.random(1,3)
    end
    
    --mama mia
    local angles = {
      helpers.rotate(1.5,helpers.anglepoints(self.x,self.y,cs.player.x,cs.player.y - 3),0,0),
      helpers.rotate(1.5,helpers.anglepoints(self.x,self.y,cs.player.x,cs.player.y - 3)-20,0,0),
      helpers.rotate(1.5,helpers.anglepoints(self.x,self.y,cs.player.x,cs.player.y - 3)+20,0,0),
      helpers.rotate(1.5,helpers.anglepoints(self.x,self.y,cs.player.x,cs.player.y - 3)-40,0,0),
      helpers.rotate(1.5,helpers.anglepoints(self.x,self.y,cs.player.x,cs.player.y - 3)+40,0,0)
    }
    
    --i cooka tha spaghett
    if bullnum == 1 then
      em.init('enemybullet',{x=self.x, y=self.y,
        dx=angles[1][1],dy=angles[1][2],
        hbsize = 3,
        size = 4,
        canv=self.canv,
        all_canv = true
      })
    elseif bullnum == 2 then
      em.init('enemybullet',{x=self.x, y=self.y,
        dx=angles[2][1],dy=angles[2][2],
        hbsize = 3,
        size = 4,
        canv=self.canv,
        all_canv = true
      })
      em.init('enemybullet',{x=self.x, y=self.y,
        dx=angles[3][1],dy=angles[3][2],
        hbsize = 3,
        size = 4,
        canv=self.canv,
        all_canv = true
      })
    else --PLEASE FOR THE LOVE OF GOD FIX THIS LATER
      em.init('enemybullet',{x=self.x, y=self.y,
        dx=angles[1][1],dy=angles[1][2],
        hbsize = 3,
        size = 4,
        canv=self.canv,
        all_canv = true
      })
      em.init('enemybullet',{x=self.x, y=self.y,
        dx=angles[4][1],dy=angles[4][2],
        hbsize = 3,
        size = 4,
        canv=self.canv,
        all_canv = true
      })
      em.init('enemybullet',{x=self.x, y=self.y,
        dx=angles[5][1],dy=angles[5][2],
        hbsize = 3,
        size = 4,
        canv=self.canv,
        all_canv = true
      })
    end
    
    if spinsleft ~= 0 then
      self:spin(spinsleft)
    else
      for i = 0,11 do
        ang1 = helpers.rotate(1.5,i*30,0,0)
          em.init('enemybullet',{x=self.x, y=self.y,
          dx=ang1[1],dy=ang1[2],
          --hbsize = 3,
          --size = 4,
          canv=self.canv,
          all_canv = true
        })
      end
      
      self.shakecharge = 0.2
      rw:ease(0,1,'linear',0,self,'shakecharge')
      rw:ease(0,1,'outQuad',360,self,'r')
      rw:func(2,function()
        self:changestate()
      end)
      rw:play()
    end
  end)
  rw:play({bpm = 260 - (spinsleft*10)})
      
end

function Crusher:cardinalcharge()
  self.endingstate = true
  self.chargeangle = math.floor((helpers.anglepoints(self.x,self.y,cs.player.x,cs.player.y - 3)/90)+0.5)*90
  local ang = helpers.rotate(3,self.chargeangle,0,0)
  self.chargex = ang[1]
  self.chargey = ang[2]
  self.dx = self.chargex
  self.dy = self.chargey
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
  
  local hit = self:move(dt,{knockback = 0})
  if hit then
    if self.state == 1 then
      print('hit wall')
      self.dx = 0
      self.dy = 0
      self.shakecharge = 0.15
      
      local ang1 = helpers.rotate(3,self.chargeangle+150,0,0)
      local ang2 = helpers.rotate(3,self.chargeangle-150,0,0)
      local ang3 = helpers.rotate(3,self.chargeangle-180,0,0)
      
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
      if cs.level ~= 0 then
        em.init('enemybullet',{x=self.x, y=self.y,
          dx=ang3[1],dy=ang3[2],
          hbsize = 3,
          size = 4,
          canv=self.canv,
          all_canv = true
        })
      end
      rw:ease(0,1,'linear',0,self,'shakecharge')
      rw:func(1,function()
        self:changestate()
      end)
      rw:play()
    elseif self.state == 2 then
      print('hit wall')
      self.dx = 0
      self.dy = 0
      self.shakecharge = 0.15
      
      local ang1 = helpers.rotate(2,self.chargeangle+135,0,0)
      local ang2 = helpers.rotate(2,self.chargeangle-135,0,0)
      local ang3 = helpers.rotate(2,self.chargeangle-180,0,0)
      
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
      if cs.level ~= 0 then
        em.init('enemybullet',{x=self.x, y=self.y,
          dx=ang3[1],dy=ang3[2],
          hbsize = 3,
          size = 4,
          canv=self.canv,
          all_canv = true
        })
      end
    
      rw:ease(0,1,'linear',0,self,'shakecharge')
      rw:func(1,function()
        if self.state == 2 and self.statetimer > 0 then
          self:cardinalcharge()
        else
          self.endingstate = false
        end
      end)
      rw:play()
    end
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