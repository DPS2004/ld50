echo "---------------------------cleaning up---------------------------"
rmdir /s/q release
rmdir /s/q release_switch


echo "---------------------------switch build---------------------------"
del project.lua
copy projects\switch.lua project.lua
boon build . --target love
ren release release_switch
copy switchassets\love.elf release_switch\love.elf
copy switchassets\icon.jpg release_switch\icon.jpg
cd release_switch
mkdir romfs
cp "Hypercube Warrior.love" "romfs/game.love"
nacptool --create "Hypercube Warrior" "Bubbletabby" "0.1.0" game.nacp
elf2nro love.elf "hcwarrior.nro" --icon ="icon.jpg" --nacp="game.nacp" --romfsdir="romfs"
cd ..

echo "---------------------------cleaning up---------------------------"

del project.lua
copy projects\debug.lua project.lua

echo "---------------------------finished!---------------------------"