#! /bin/bash

kernel () {
    printf "  $(uname -r)"
}

memory () {
    mem=$(free -h | awk '/^Mem:/ {print $3}' | sed 's/i//g')
    printf "  $mem"
}

wlan () {
    case "$(cat /sys/class/net/wlp12s0/operstate 2>/dev/null)" in
    up) printf "󰖩  $(nmcli -t -f name,device connection show --active | grep wlp12s0 | cut -d\: -f1)" ;;
    down) printf "󰖪 " ;;
    esac
}

bluetooth ()
{
    status=$(systemctl is-active bluetooth.service)

    if [ "$status" == "active" ]
    then
        printf ''
    else
        printf '󰂲'
    fi
}

volume () {
    curStatus=$(pactl get-sink-mute @DEFAULT_SINK@)
    volume=$(pactl get-sink-volume @DEFAULT_SINK@ | tail -n 2 | sed -e 's,.* \([0-9][0-9]*\)%.*,\1,' | head -n 1)

    if [ "${curStatus}" = 'Mute: yes' ]
    then
        printf "󰖁 $volume%%"
    else
        printf "󰕾 $volume%%"
    fi
}

battery () {
    capacity=$(cat /sys/class/power_supply/BAT0/capacity)
    printf "  $capacity%%"
}

clock () {
    printf "$(date '+%m/%d/%y - %H:%M')"
}

cmus () {
    if ps -C cmus > /dev/null; then
        status=`cmus-remote -Q |
            grep --text '^status' |
            sed 's/status //' | 
            awk '{gsub("status ", "");print}'`
        artist=`cmus-remote -Q | 
            grep --text '^tag artist' | 
            sed '/^tag artistsort/d' | 
            awk '{gsub("tag artist ", "");print}'`
        title=`cmus-remote -Q  | 
            grep --text '^tag title' | 
            sed -e 's/tag title //' |
            awk '{gsub("tag title ", "");print}'`
        if [ "$status" == "playing" ] 
        then 
            printf "   $artist - $title |"; 
        else
            printf "   $artist - $title |";
        fi
        else printf ""; 
    fi
}

while true; do
    # Desktop Version
    sleep 1 && xsetroot -name "$(cmus) $(kernel) | $(memory) | $(wlan) | $(volume) | $(clock)"

    # Laptop Version
    # sleep 1 && xsetroot -name "$(cmus) $(kernel) | $(memory) | $(wlan) | $(bluetooth) $(volume) | $(battery) | $(clock)"
done &
