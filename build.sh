BLUE='\033[1;34m'
PINK='\033[1;35m'
NC='\033[0m'
UNDERLINE='\033[4m'

FancyPrint () {
    BLUEDASH="$BLUE-"
    PINKDASH="$PINK-"
    DASHES=$BLUEDASH$PINKDASH$BLUEDASH$PINKDASH$BLUE
    printf "%b%b%b%b " $DASHES $DASHES $DASHES $NC
    printf "$BLUE$UNDERLINE$1$NC"
    printf " %b%b%b%b\n" $DASHES $DASHES $DASHES $NC
}

FancyPrint 'cleanup'
rm -rf release
rm -rf release_pc
rm -rf release_web
rm -rf release_editor

FancyPrint 'pc build'
rm project.lua
cp projects/pc.lua project.lua
boon build . --target all
mv release release_pc

FancyPrint 'level editor'
rm project.lua
cp projects/editor.lua project.lua
boon build . --target all
mv release release_editor

FancyPrint 'web build'
rm project.lua
cp projects/web.lua project.lua
boon build . --target all
mv release release_web
cd release_web
npx love.js -t "Hypercube Warrior" "Hypercube Warrior.love" web
cd ..

FancyPrint 'cleanup'
rm project.lua
cp projects/debug.lua project.lua
