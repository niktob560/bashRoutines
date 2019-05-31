#!/bin/sh

notification_id="991049"

if [ $1 == 0 ]; then
	pactl set-sink-mute @DEFAULT_SINK@ toggle
else
	pactl set-sink-mute @DEFAULT_SINK@ off
	pactl set-sink-volume @DEFAULT_SINK@ $1
fi

var=$(pactl list sinks | rg bluetooth);

if [[ $var != "" ]]; then
	vol=$(pactl list sinks | rg -A 2 -B 8 "bluetooth" | rg "Громкость" | awk -F '/' '{print $4}');
	muted=$(pactl list sinks | rg -A 2 -B 8 "bluetooth" | rg "Звук выключен" | awk '{print $3}' | head -1)
else
	vol=$(pactl list sinks | rg "Громкость:" | head -1 | awk -F '/' '{print $4}')
	muted=$(pactl list sinks | rg "Звук выключен" | awk '{print $3}' | head -1)
fi

#echo $vol
vol=${vol::-2}
#echo $vol
vol=$(($vol+0))
icon=""
if [[ $muted == 'yes' || $vol == 0 ]]; then
	icon="/usr/share/icons/Faba/48x48/notifications/notification-audio-volume-muted.svg"
	#iconn="audio-volume-muted.png"
	vol=0
else 
	if [ "$vol" -lt "33" ]; then
		icon="/usr/share/icons/Faba/48x48/notifications/notification-audio-volume-low.svg"
	else 
		if [[ $vol -lt 66 ]]; then
			icon="/usr/share/icons/Faba/48x48/notifications/notification-audio-volume-medium.svg"
		else
			icon="/usr/share/icons/Faba/48x48/notifications/notification-audio-volume-high.svg"
		fi
	fi
fi
bar=$(seq -s "─" $(($vol/5)) | sed 's/[0-9]//g')
dunstify "$vol""     ""$bar" -i "$icon" -t 1000 -h int:value:"$vol" -h string:synchronous:"$bar" -r "$notification_id"
#notify-send " " -i $icon -h int:value:$(echo $vol) -h string:synchronous:volume 
