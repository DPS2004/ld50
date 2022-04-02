local project = {}

project.release = false

project.name = 'DPS2004 love2d template'

project.initstate = 'cubetest'


project.res = {}

project.res.x = 352
project.res.y = 198
project.res.s = 1


project.ctrls = {
  left = {"key:left",  "axis:rightx-", "button:dpleft"},
  right = {"key:right",  "axis:rightx+", "button:dpright"},
  up = {"key:up", "axis:righty-", "button:dpup"},
  down = {"key:down", "axis:righty+", "button:dpdown"},
  accept = {"key:space", "key:return", "button:a"},
  back = {"key:escape", "button:b"},
  f5 = {"key:f5"},
  k1 = {"key:1"},
  k2 = {"key:2"},
  k3 = {"key:3"},
  k4 = {"key:4"},
  l = {"key:l"},
  v = {"key:v"},
  q = {"key:q"},
  e = {"key:e"},
  ctrl = {"key:lctrl"},
  s = {"key:s"},
  c = {"key:c"},
  
  
  mouse1 = {"mouse:1"},
  mouse2 = {"mouse:2"},
  mouse3 = {"mouse:3"}
}


project.acdelt = true

return project