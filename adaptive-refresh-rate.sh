#! /bin/bash

echo "launch refresh-rate"

INTERVAL=5
STATUS=0

if [ $# -ne 0 ]; then
	if  [ $1 -gt 5 ]; then 
		INTERVAL=$1
	else 
		echo "Minimum interval 5 seconds!"
		exit -1
	fi
fi

if [[ "$(acpi -a)" =~ "on" ]]; then
	STATUS=1
	echo "120"
	$(xrandr --output eDP --mode 2880x1920 --rate 120.00)
else
	STATUS=0
	echo "60"
	$(xrandr --output eDP --mode 2880x1920 --rate 60.00)	
fi

echo "Start with interval $INTERVAL"

while true; do
	# Check
	POWER_MODE=$(acpi -a)

	if [[ "$POWER_MODE" =~ "off" ]] && [ $STATUS -eq 1 ]; then
        	echo "AC-OFF"
        	$(xrandr --output eDP --mode 2880x1920 --rate 60.00)
		STATUS=0
	elif [[ "$POWER_MODE" =~ "on" ]] && [ $STATUS -eq 0 ]; then
        	echo "AC-ON"
        	$(xrandr --output eDP --mode 2880x1920 --rate 120.00)
		STATUS=1
	fi

	# Wait for 5 seconds
	sleep $INTERVAL

done

exit 0
