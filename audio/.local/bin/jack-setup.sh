#! /bin/bash
jack_control start
#pajackconnect start &

jack_disconnect pulse_out:front-left system:playback_1
jack_disconnect pulse_out:front-right system:playback_2
jack_disconnect "PulseAudio JACK Sink:front-left" system:playback_1
jack_disconnect "PulseAudio JACK Sink:front-right" system:playback_2

#setsid jack-rack -s jrfleq /home/guy/flat-rack &
setsid carla /home/guy/.local/share/carla/BaseEnvironment.carxp &
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
