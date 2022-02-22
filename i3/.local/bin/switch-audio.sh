#! /usr/bin/env bash

echo "Args $1 $2"
pacmd set-default-sink $1
pulseeffects --load-preset $2

