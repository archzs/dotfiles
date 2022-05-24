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

###########
# Aliases #
###########

alias ls='ls --color=auto'
alias la='ls -A'
alias ll='ls -lA'

alias ..='cd ..'

alias grep='grep --color=auto'

# Dotfile git configuration management
alias dot='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

# Bluetooth enable/disable
alias bton='sudo rfkill unblock bluetooth && sudo systemctl start bluetooth.service'
alias btoff='sudo systemctl stop bluetooth.service && sudo rfkill block bluetooth'

# youtube-dl
# Convert single video to mp3
mp3 () {
	youtube-dl --prefer-ffmpeg --extract-audio --audio-format mp3 --audio-quality 128K -o '%(title)s.%(ext)s' "$1"
}

# Convert playlist to mp3
mp3p () {
	youtube-dl --prefer-ffmpeg --extract-audio --audio-format mp3 --audio-quality 128K -o '%(playlist_index)s - %(title)s.%(ext)s' "$1"
}
