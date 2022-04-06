local sprites = {}


sprites.floortile = love.graphics.newImage('assets/room/floor.png')
sprites.doors = love.graphics.newImage('assets/room/doors.png')
sprites.instructions = love.graphics.newImage('assets/room/instructions.png')

sprites.gun = love.graphics.newImage('assets/player/gun.png')
sprites.playerbullet = love.graphics.newImage('assets/player/playerbullet.png')

sprites.enemyface = love.graphics.newImage('assets/enemy/enemy_face.png')
sprites.walker = love.graphics.newImage('assets/enemy/walker.png')
sprites.walkshoot = love.graphics.newImage('assets/enemy/walkshoot.png')
sprites.bouncer = love.graphics.newImage('assets/enemy/bouncer.png')
sprites.cannon = love.graphics.newImage('assets/enemy/cannon.png')
sprites.bullet = love.graphics.newImage('assets/enemy/enemybullet.png')

sprites.bossface = love.graphics.newImage('assets/enemy/boss_face.png')

sprites.scorecounter = love.graphics.newImage('assets/ui/scorecounter.png')
sprites.numbers = love.graphics.newImage('assets/ui/numbers.png')

sprites.stadium = love.graphics.newImage('assets/bg/stadium.png')
sprites.stage = love.graphics.newImage('assets/bg/stage.png')

sprites.logo = love.graphics.newImage('assets/menu/logo.png')

sprites.editortiles = love.graphics.newImage('assets/editor/tiles.png')
sprites.editorcursor = love.graphics.newImage('assets/editor/cursor.png')

return sprites