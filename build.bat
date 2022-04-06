echo "---------------------------cleaning up---------------------------"
rmdir /s/q release
rmdir /s/q release_pc
rmdir /s/q release_web
rmdir /s/q release_editor

echo "---------------------------pc build---------------------------"
del project.lua
copy projects\pc.lua project.lua
boon build . --target all
ren release release_pc

echo "---------------------------level editor---------------------------"
del project.lua
copy projects\editor.lua project.lua
boon build . --target all
ren release release_editor

echo "---------------------------web build---------------------------"
del project.lua
copy projects\web.lua project.lua
boon build . --target love
ren release release_web
cd release_web
start npx love.js.cmd -t "Hypercube Warrior" "Hypercube Warrior.love" web
cd ..

echo "---------------------------cleaning up---------------------------"

del project.lua
copy projects\debug.lua project.lua

echo "---------------------------finished!---------------------------"