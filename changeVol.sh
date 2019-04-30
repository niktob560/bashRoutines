#!/bin/sh
if [ $1 == 0 ]; then
	pactl set-sink-mute @DEFAULT_SINK@ toggle
else
	pactl set-sink-mute @DEFAULT_SINK@ off
	pactl set-sink-volume @DEFAULT_SINK@ $1
fi
vol=0
muted=$(pactl list sinks | rg Mute | awk '{ print $2 }')
vol=$(pactl list sinks | rg Volume: | awk -F '/' '{ print $4 }' | rg \[\\d] | tail -1)
vol=${vol::-2}
icon=""
if [[ $muted == 'yes' ]]; then
	icon="notification-audio-volume-muted"
	vol=0
else 
	if [ "$vol" -lt "33" ]; then
		icon="notification-audio-volume-low"
	else 
		if [[ $vol -lt 66 ]]; then
			icon="notification-audio-volume-medium"
		else
			icon="notification-audio-volume-high"
		fi
	fi
fi
notify-send " " -i $icon -h int:value:$(echo $vol) -h string:synchronous:volume 
