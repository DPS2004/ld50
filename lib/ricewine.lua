local ricewine = {
  tweens = {},
  startbeat = 0,
  bpm = 100,
  functween = {x=0},
  queuedtweens = {}
}
ricewine.flux = flux
if not ricewine.flux then
  error('flux.lua not found!')
end

function ricewine:easenow(start,length,easefn,val,obj,param)
  if start < self.startbeat then
    obj[param] = val
  else
  
    start = (start - self.startbeat) * (1/self.bpm)*3600
    length = length * (1/self.bpm)*3600
    
    local kvtable = {}
    kvtable[param] = val
    table.insert(self.tweens,self.flux.to(obj, length, kvtable):ease(easefn):delay(start))
  end
end

function ricewine:funcnow(start,dofunc)
  if start < self.startbeat then
    dofunc()
  else
    start = (start - self.startbeat) * (1/self.bpm)*3600
    table.insert(self.tweens,self.flux.to(self.functween, 0, {x=0}):delay(start):onstart(dofunc))
  end
end

function ricewine:ease(start,length,easefn,val,obj,param)
  table.insert(self.queuedtweens,function() self:easenow(start,length,easefn,val,obj,param) end)
end

function ricewine:func(start,dofunc)
  table.insert(self.queuedtweens,function() self:funcnow(start,dofunc) end)
end

function ricewine:stopall()
  print('stopping')
  for i,v in ipairs(self.tweens) do
    v:stop()
  end
end

function ricewine:play(params)
  params = params or {bpm = 60,startbeat=0}
  if params.startbeat then
    self.startbeat = params.startbeat
  end
  if params.bpm then 
    self.bpm = params.bpm
  end
  if params.song then
    self.funcnow(0,function() self.song = te.play(song,'stream',{'ricewine_music','music'}) end)
  end
  for i,v in ipairs(self.queuedtweens) do
    v()
  end
  self.queuedtweens = {}
  self.startbeat = 0
end

return ricewine