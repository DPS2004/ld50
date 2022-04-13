local templates = {}

templates.player = {}

templates.player.base = ez.newtemplate('player/base.png',19,0)
templates.player.gun = ez.newtemplate('player/gun.png',9,0)

templates.block = ez.newtemplate('room/block.png',10,0)

templates.pressbutton = ez.newtemplate("ui/pressbutton.png",8,30)


return templates