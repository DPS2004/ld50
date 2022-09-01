local templates = {}

templates.player = {}

templates.player.base = ez.newtemplate('player/base.png',19,0)
templates.player.gun = ez.newtemplate('player/gun.png',9,0)

templates.box = ez.newtemplate('room/box.png',10,0)

templates.pressbutton = ez.newtemplate("ui/pressbutton.png",8,30)

templates.table = ez.newtemplate("room/table.png",34,20)
templates.secretary = ez.newtemplate("room/secretary.png",9,0)


return templates