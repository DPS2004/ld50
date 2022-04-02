local project = {}

project.release = false

project.name = 'DPS2004 love2d template'

project.initstate = 'game'


project.res = {}

project.res.x = 352
project.res.y = 198
project.res.s = 3


project.ctrls = {
  left = {"key:a",  "axis:rightx-", "button:dpleft"},
  right = {"key:d",  "axis:rightx+", "button:dpright"},
  up = {"key:w", "axis:righty-", "button:dpup"},
  down = {"key:s", "axis:righty+", "button:dpdown"},
  accept = {"key:space", "key:return", "button:a"},
  back = {"key:escape", "button:b"},
  f5 = {"key:f5"},
  k1 = {"key:1"},
  k2 = {"key:2"},
  k3 = {"key:3"},
  k4 = {"key:4"},
  
  
  mouse1 = {"mouse:1"},
  mouse2 = {"mouse:2"},
  mouse3 = {"mouse:3"}
}


project.acdelt = true

return project