#!/bin/bash

# This has an opinion of using pacaur as the aur helper

function _sudo () {
    echo '>' sudo $@
    sudo $@
}

# Install packages
_sudo pacman -S pacaur entr dart --needed
pacaur -S direnv flutter android-studio --needed

# Fix flutter install permissions
_sudo groupadd flutterusers
_sudo gpasswd -a $USER flutterusers

_sudo chown -R :flutterusers /opt/flutter
_sudo chmod -R g+w /opt/flutter
