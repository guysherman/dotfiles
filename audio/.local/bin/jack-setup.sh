#! /bin/bash
SAMPLE_RATE=44100

CARLA_SESSION=/home/guy/.local/share/carla/BaseEnvironment.carxp
jack_control ds alsa

if aplay -l | grep US4x4; then
jack_control dps device hw:US4x4
jack_control dps capture hw:US4x4
jack_control dps playback hw:US4x4
jack_control dps period 256
CARLA_SESSION=/home/guy/.local/share/carla/SpeakerAndHeadphones.carxp 
elif aplay -l | grep USB; then
jack_control dps device hw:USB
jack_control dps capture hw:USB
jack_control dps playback hw:USB
jack_control dps period 512
else
jack_control dps device hw:PCH
jack_control dps capture hw:PCH
jack_control dps playback hw:PCH
jack_control dps period 1024
fi

jack_control dps rate $SAMPLE_RATE
jack_control dps nperiods 2
jack_control dps hwmeter false
jack_control dps duplex true
jack_control dps softmode false
jack_control dps monitor false
jack_control dps dither n
jack_control dps shorts false


jack_control start
#pajackconnect start &

jack_disconnect pulse_out:front-left system:playback_1
jack_disconnect pulse_out:front-right system:playback_2
jack_disconnect "PulseAudio JACK Sink:front-left" system:playback_1
jack_disconnect "PulseAudio JACK Sink:front-right" system:playback_2

#setsid jack-rack -s jrfleq /home/guy/flat-rack &
setsid carla $CARLA_SESSION &
sleep 5
#jack_connect pulse_out:front-left jack_rack_jrfleq:in_1 
#jack_connect pulse_out:front-right jack_rack_jrfleq:in_2
#jack_connect "PulseAudio JACK Sink:front-left" jack_rack_jrfleq:in_1 
#jack_connect "PulseAudio JACK Sink:front-right" jack_rack_jrfleq:in_2
#jack_connect jack_rack_jrfleq:out_1 system:playback_3   
#jack_connect jack_rack_jrfleq:out_2 system:playback_4

#setsid jack-rack -s jrhpeq /home/guy/headphone-rack &
#sleep 5
#jack_connect pulse_out:front-left jack_rack_jrhpeq:in_1 
#jack_connect pulse_out:front-right jack_rack_jrhpeq:in_2
#jack_connect "PulseAudio JACK Sink:front-left" jack_rack_jrhpeq:in_1 
#jack_connect "PulseAudio JACK Sink:front-right" jack_rack_jrhpeq:in_2
#jack_connect jack_rack_jrhpeq:out_1 system:playback_1 
#jack_connect jack_rack_jrhpeq:out_2 system:playback_2

setsid jack-passthru &
setsid jack-passthru -n jack-passthru-out &
pacmd set-default-sink jack_out

#aconnect 36:0 128:0
