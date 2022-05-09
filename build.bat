echo "---------------------------cleaning up---------------------------"
rmdir /s/q release
rmdir /s/q release_pc
rmdir /s/q release_editor
rmdir /s/q release_debug

echo "---------------------------debug pc build---------------------------"
del project.lua
copy projects\debug.lua project.lua
boon build . --target all
ren release release_debug

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

echo "---------------------------cleaning up---------------------------"

del project.lua
copy projects\debug.lua project.lua

echo "---------------------------finished!---------------------------"