#!/usr/bin/env sh

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# Launch bar1 and bar2
if type "xrandr"; then
    MONITOR=HDMI-0 polybar --reload top &
else
  polybar --reload top &
fi
echo "Bars launched..."
