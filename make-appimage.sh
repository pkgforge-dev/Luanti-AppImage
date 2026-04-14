#!/bin/sh

set -eu

ARCH=$(uname -m)
VERSION=$(pacman -Q luanti | awk '{print $2; exit}') # example command to get version of application here
export ARCH VERSION
export OUTPATH=./dist
export ADD_HOOKS="self-updater.hook"
export UPINFO="gh-releases-zsync|${GITHUB_REPOSITORY%/*}|${GITHUB_REPOSITORY#*/}|latest|*$ARCH.AppImage.zsync"
export ICON=/usr/share/icons/hicolor/128x128/apps/luanti.png
export DESKTOP=/usr/share/applications/org.luanti.luanti.desktop
export DEPLOY_OPENGL=1

# Deploy dependencies
quick-sharun \
	/usr/bin/luanti    \
	/usr/bin/minetest  \
	/usr/lib/libldap.so*

# Additional changes can be done in between here

# Turn AppDir into AppImage
quick-sharun --make-appimage

# Test the app for 12 seconds, if the test fails due to the app
# having issues running in the CI use --simple-test instead
quick-sharun --test ./dist/*.AppImage
