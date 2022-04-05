function love.conf(t)
  project = require('project')
  project.res.cx = project.res.x / 2
  project.res.cy = project.res.y / 2
  t.externalstorage = true
  t.identity = 'hypercube_warrior_ld50'
  
  t.window.usedpiscale = false
  if not project.release then
    t.console = true
  end
  
  t.window.width = project.res.x * project.res.s
  t.window.height = project.res.y * project.res.s
  
  
end
