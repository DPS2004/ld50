Secretary = class('Secretary',Entity)

function Secretary:initialize(params)
  
  self.layer = 11 -- lower layers draw first
  self.uplayer = 0 --lower uplayer updates first
  self.x = 0
  self.y = 0
  
  self.level = nil
  
  self.shot = false
  
  self.monitorspr = sprites.monitor
  self.tablespr = ez.newanim(templates.table)
  self.secretaryspr = ez.newanim(templates.secretary)
  
  self.sprframe = 0
  
  self.noticedplayer = false
  
  self.looktimer = 0
  
  self.startedtalking = false
  
  self.hitbox = {x=61,y=44,width=9,height=13}
  
  Entity.initialize(self,params)

end


function Secretary:update(dt)
  prof.push("secretary update")
  ez.update(self.tablespr,dt)
  
  if not self.shot and cs.map[cs.croom].tutorialsecret then
    if cs.player.x <=108 and (not self.noticedplayer) then
      self.noticedplayer = true
    end
    if self.noticedplayer then
      if self.looktimer < 3 then
        self.looktimer = self.looktimer + dt/15
      else
        if not self.startedtalking then
          self.startedtalking = true
          print('talkingtoplayer')
          cs.playdialog(22)
        end
      end
      
      if self.looktimer > 3 then
        self.looktimer = 3
      end
      
      self.sprframe = math.floor(self.looktimer)
    end
    
    for i,v in ipairs(entities) do
      if v.name == 'playerbullet' then
        if helpers.collide(self.hitbox,v.hitbox) then
          self.shot = true
          te.play('assets/sfx/secretary_hit.ogg','static',{'secretary_hit','sfx'},1)
          if cs.currentbubble then cs.currentbubble:cleanup() end
          if cs.oldbubble then cs.oldbubble:cleanup() end
          if cs.newerbubble then cs.newerbubble:cleanup() end
        end
      end
    end
  end
  if self.shot then
    self.sprframe = 4
  end
  prof.pop("secretary update")
end

function Secretary:draw(override)
  prof.push("secretary draw")
  color()
  if override or cs.map[cs.croom].tutorialsecret then
    love.graphics.draw(self.monitorspr,48,0)
    love.graphics.draw(shuv.lastframe,49,17,0,1/(shuv.canvas:getWidth()/32),1/(shuv.canvas:getHeight()/18))
    if override then
      ez.draw(self.tablespr,48,0)
      ez.drawframe(self.secretaryspr,self.sprframe,61,42)
    end
    
  end
  prof.pop("secretary draw")
end

return Secretary