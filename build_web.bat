echo "---------------------------cleaning up---------------------------"
rmdir /s/q release
rmdir /s/q release_web


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