# ~/.bashrc

# If not running interactively, don't do anything
[[ $- != *i* ]] && return
PS1='[\u@\h \W]\$ '

#########################
# Environment Variables #
#########################

export TERM='st-256color'
export EDITOR='vim'
export VISUAL='vim'
export HISTCONTROL=ignoreboth
export GTK_THEME=Arc-Dark
export QT_STYLE_OVERRIDE=kvantum
export QT_QPA_PLATFORMTHEME=qt5ct

###########
# Aliases #
###########

alias ls='ls --color=auto'
alias la='ls -a'
alias ll='ls -la'

alias ..='cd ..'

alias grep='grep --color=auto'

# Dotfile git configuration management
alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

# Bluetooth enable/disable
alias bton='sudo rfkill unblock bluetooth && sudo systemctl start bluetooth.service'
alias btoff='sudo systemctl stop bluetooth.service && sudo rfkill block bluetooth'

# qView

alias qq='qview'

# yt-dlp
# Convert video to mp3
mp3 () {
    yt-dlp -x --audio-format mp3 --audio-quality 0 -o "%(playlist_index&{}|)s%(title)s.%(ext)s" "$1"
}

# Convert video to opus
opus () {
    yt-dlp -x --audio-format opus -f 250 -o "%(title)s.%(ext)s" "$1"
}

# Select format of video to download
yt () {
    yt-dlp -f - "$1"
}

# Download best video merged with best audio as mp4
mp4 () {
    yt-dlp -S ext:mp4 "$1"
}

# Download the best video merged with best audio no larger than 720p as mp4
720 () {
    yt-dlp -S "res:720,fps,ext:mp4" "$1"
}

# Download the best video merged with best audio no larger than 1080p as mp4
1080 () {
    yt-dlp -S "res:1080,fps,ext:mp4" "$1"
}

# Download best video merged with best audio as mkv
mkv () {
    yt-dlp --merge-output-format mkv "$1"
}

# sox spectrogram
soxs () {
    sox "$1" -n spectrogram
}

# convert flac files to 16-bit/44.1
s16 () {
    ffmpeg -i "$1" -sample_fmt s16 -ar 44100 "$HOME/downloads/$1"
}

# Trim audio file using ffmpeg
atrim () {
    echo "${1##*.}"
    ffmpeg -i "$1" -ss "$2" -to "$3" -acodec copy "trim.${1##*.}"
}

flt () {
    ffmpeg -i "$1" -sample_fmt fltp "/home/zera/workspace/converted/$1"
}

brpc () {
    export UNZIP_DISABLE_ZIPBOMB_DETECTION=TRUE
    fcrackzip -v -b -c 1 -l 1-8 "$1" > pass
    vim -c ':1d | :1d | :%s/possible pw found: //g | :%s/ ()//g | :wq' pass
    while IFS= read -r line; do
        echo "$line" 
        echo $(unzip -o -P "$line" "$1")
    done < pass &> ptest
    vim -c ':%s/[0-9]*\n\n  error:.*\n bad CRC.*\n    (may.*\nArchive.*//g | :%s/[0-9]*\n bad CRC.*\n    (may.*\nArchive.*//g | :%s/checking pw.*\n   skipping.*\nArchive.*//g | :%s/[0-9]*\n(incomplete.*\n  error.*//g | :g/[0-9]*\nArchive.*/m0 | :wq' ptest
}
