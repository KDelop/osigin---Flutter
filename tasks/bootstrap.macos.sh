#!/bin/bash

## Flutter setup script
## Please install xcode and android studio before running this script.

set -e

brew --version || {
  echo "Please install homebrew https://brew.sh"
  exit 1;
}

flutter --version || {
    echo "Flutter not detected. Installing flutter."
    brew cask install flutter
}

test -e /Applications/Android\ Studio.app || {
  echo "Flutter not detected. Tnstalling with brew"
  brew cask install android-studio
}

flutter --version || {
    echo "Flutter not detected.  Installing flutter."
    brew cask install flutter
}

gem list cocoapods | grep -Eqo 'cocoapods \(.+?\)' || {
  echo "Installing cocoapods..."
  sudo gem install cocoapods
}

direnv --version || {
  echo "direnv not installed... installing direnv"
  brew install direnv
}

cat << EOF
[FINAL STEPS]
- Install Xcode from app store or the xip from the developer network
- Run initial setup Android Studio in your Applications
  - You may have to attend to it's installation of the Intel system stuff.
- Run "flutter doctor" and fix the things it reports
  - You don't need to fix the dart/flutter plugins for Android Studio 
EOF
