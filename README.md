# Lightrun

## Setup

### Install Haxe (Windows/Mac)
https://haxe.org/download/

### Install HashLink (Windows)
https://github.com/HaxeFoundation/hashlink/releases

### Install Haxe (Ubuntu)
sudo add-apt-repository ppa:haxe/releases -y
sudo apt-get update
sudo apt-get install haxe -y
mkdir ~/haxelib && haxelib setup ~/haxelib

### Install Hashlink (Linux)
git clone https://github.com/HaxeFoundation/hashlink.git
sudo apt-get install libpng-dev libturbojpeg-dev libvorbis-dev libopenal-dev libsdl2-dev libmbedtls-dev libuv1-dev
cd hashlink
make
make install
cp -f /usr/local/lib/libhl*  /lib
cp -f /usr/local/lib/*.hdll  /lib

### Install Deps
haxelib install hlsdl
haxelib git castle https://github.com/ncannasse/castle.git
haxelib git heaps https://github.com/HeapsIO/heaps.git
haxelib git deepnightLibs https://github.com/deepnight/deepnightLibs.git
haxelib git echo https://github.com/AustinEast/echo.git
haxelib git redistHelper https://github.com/deepnight/redistHelper.git

## Profile

### Create Profile
hl --profile 1000 bin/client.hl

### Convert Profile Dump
hl profiler.hl hlprofile.dump

## Distribute

### Make Dist Build (Windows/Mac/Linux)
haxelib run hxdist hl.sdl.hxml
