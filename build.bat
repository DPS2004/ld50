echo "cleaning up"
rmdir /s/q release
rmdir /s/q release_pc
rmdir /s/q release_web

del project.lua
copy projects\pc.lua project.lua
boon build . --target all
ren release release_pc

del project.lua
copy projects\web.lua project.lua
boon build . --target love
ren release release_web

cd release_web
npx love.js.cmd -c -t "Hypercube Warrior" "Hypercube Warrior.love" web

cd web

python -m http.server 8000