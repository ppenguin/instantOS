#!/bin/bash

# installs dependencies for instantOS

LINK="https://raw.githubusercontent.com/instantos/instantos/master"

# install on arch based system
pacinstall() {
    for i in "$@"; do
        { pacman -iQ "$i" || command -v "$i"; } &>/dev/null && continue
        echo "Installing $i"
        sudo pacman -S --noconfirm "$i" &>/dev/null
    done
}

# install on ubuntu based system
aptinstall() {
    for i in "$@"; do
        { dpkg -l "$i" || command -v "$i"; } &>/dev/null && continue
        echo "Installing $i"
        sudo apt-get install -y "$i" &>/dev/null
    done
}

if command -v pacman &>/dev/null; then
    ISARCH=TRUE
elif command -v apt &>/dev/null; then
    ISUBUNTU=TRUE
else
    echo "distro not supported"
    exit
fi

# cross distro install command
ipkg() {
    if [ -n "$ISARCH" ]; then
        pacinstall "$@"
    elif [ -n "$ISUBUNTU" ]; then
        aptinstall "$@"
    fi
}

ipkg wget
ipkg hwinfo

if cat /etc/os-release | grep -iq 'name.*arch' ||
    cat /etc/os-release | grep -iq 'name.*manjaro'; then
    echo "setting up arch specific stuff"

    sudo pacman -Syu --noconfirm

    pacinstall picom
    pacinstall arc-gtk-theme
    pacinstall acpi
    pacinstall xrandr

    pacinstall slop
    pacinstall xorg-xsetroot
    pacinstall xorg-fonts-misc

    pacinstall tar

    pacinstall autoconf
    pacinstall automake
    pacinstall binutils
    pacinstall bison
    pacinstall fakeroot
    pacinstall file
    pacinstall findutils
    pacinstall flex
    pacinstall gawk
    pacinstall gcc
    pacinstall gettext
    pacinstall grep
    pacinstall groff
    pacinstall gzip
    pacinstall libtool
    pacinstall m4
    pacinstall make
    pacinstall pacman
    pacinstall patch
    pacinstall pkgconf
    pacinstall sed
    pacinstall sudo
    pacinstall texinfo
    pacinstall which

    pacinstall p7zip

    if ! command -v panther_launcher; then
        wget -q "https://www.rastersoft.com/descargas/panther_launcher/panther_launcher-1.12.0-1-x86_64.pkg.tar.xz"
        sudo pacman -U --noconfirm panther_launcher*.pkg.tar.xz
        rm panther_launcher*.pkg.tar.xz
    fi

    if hwinfo --gfxcard --short | grep -iE 'nvidia.*(gtx|rtx|titan)'; then
        echo "installing nvidia graphics drivers"
        sudo mhwd -a pci nonfree 0300
        if grep -Eiq 'instantos|manjaro' /etc/os-release; then
            if pacman -iQ linux54; then
                pacinstall linux54-nvidia-440x
            fi

            if pacman -iQ linux419; then
                pacinstall linux419-nvidia-440xx
            fi
        else
            if pacman -iQ linux-lts; then
                pacinstall nvidia-lts
            fi
            pacinstall nvidia
        fi
    fi
fi

# ubuntu specific stuff
if grep -iq 'name.*ubuntu' </etc/os-release; then

    sudo apt-get update
    sudo apt-get upgrade -y

    aptinstall compton

    aptinstall acpi
    aptinstall xrandr

    aptinstall x11-xserver-utils # xsetroot
    aptinstall slop

    aptinstall tar
    aptinstall arc-theme
    aptinstall p7zip-full
    aptinstall p7zip-rar

    if ! command -v panther_launcher; then
        wget -q "https://www.rastersoft.com/descargas/panther_launcher/panther-launcher-xenial_1.12.0-ubuntu1_amd64.deb"
        sudo dpkg -i panther-launcher*.deb
        sudo apt-get install -fy
        rm panther-launcher*.deb
    fi
fi

# dont repeat packages present in both distro families
ipkg bash
ipkg dash
ipkg tmux

ipkg git
ipkg subversion

ipkg dialog
ipkg neovim
ipkg fzf
ipkg ranger
ipkg sl

ipkg ffmpeg
ipkg feh
ipkg mpv

ipkg arandr
ipkg qt5ct
ipkg lxappearance

ipkg rofi
ipkg conky
ipkg dunst
ipkg rxvt-unicode

ipkg xdotool
ipkg wmctrl

ipkg nautilus
ipkg cpio
