#!/usr/bin/env bash

echo ""
pacmd list-sinks | grep "name: <" | awk '{print NR ") " $2}'
echo ""
num_sinks=$(pacmd list-sinks | grep "name: <" | wc -l)

read -p "Select default sink number (1-$num_sinks): " selected_sink

if [ $selected_sink -ge 1 -a $selected_sink -le $num_sinks ]; then
	selected_sink_name=$(pacmd list-sinks | grep "name: <" | awk -v "selsink=$selected_sink" 'FNR == selsink {print $2}' | sed 's/[<>]//g')
	echo "You selected sink number $selected_sink ($selected_sink_name)."
	pacmd set-default-sink $selected_sink_name
else
	echo "Invalid entry number: $selected_sink"
fi
