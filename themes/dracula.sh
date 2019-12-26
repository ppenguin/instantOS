#!/bin/bash

source <(curl -Ls https://git.io/JerLG)
pb git
pb gtk

# gtk theme
if themeexists materiacula && icons_exist materiacula!; then
    echo "gtk theme dracula found"
else
    gitclone materiacula
    cd materiacula
    bash install.sh
    cd ..
    rm -rf materiacula
fi

gtktheme materiacula
gtkicons materiacula
gtkfont "Roboto 10"

setcursor paper

# rofi setup
mkdir -p ~/.config/rofi &> /dev/null
curl -s "https://raw.githubusercontent.com/paperbenni/dotfiles/master/rofi/dracula.rasi" >~/.config/rofi/dracula.rasi
echo 'rofi.theme: ~/.config/rofi/dracula.rasi' > ~/.config/rofi/config

curl -s "https://raw.githubusercontent.com/paperbenni/dotfiles/master/fonts/monaco.sh" | bash
curl -s "https://raw.githubusercontent.com/paperbenni/dotfiles/master/fonts/roboto.sh" | bash