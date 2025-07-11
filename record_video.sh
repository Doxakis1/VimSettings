#! /bin/bash
RECORDING_FILE="$HOME/.record"
RECORDING_PID=$(cat $RECORDING_FILE 2>/dev/null)

if [[ -z "$RECORDING_PID" || ! "$RECORDING_PID" =~ ^[0-9]+$ ]]; then
    ffmpeg -f x11grab -video_size 1920x1080 -i :0.0 -f alsa -i default -af:a "afftdn=nf=-75" -c:v libx264 -preset ultrafast -crf 23 -c:a aac -b:a 128k /home/$USER/$(date +"%d_%m_%H_%M_%S").mp4 &>/dev/null &
    pid=$!
    echo "$pid" > "$RECORDING_FILE"
    echo "Started recording process with PID $pid"
else
    echo "Stopping recording process $RECORDING_PID"
    kill -15 "$RECORDING_PID"
    rm "$RECORDING_FILE"
fi
