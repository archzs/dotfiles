#!/bin/sh
if [ -d "$HOME/Playlists" ]; then
    rm -r $HOME/Playlists
fi
cp -r $HOME/.config/cmus/playlists $HOME/Playlists
cd $HOME/Playlists
for f in *; do mv "$f" "$f".m3u; done     
sed -i "s/\x1FHOME\x1F\/music/\/storage\/emulated\/0\/Music/g" *
sed -i 's/.flac/.opus/g' *
