#! /bin/bash

touch /home/guy/audio-setup.ran
pushd /home/guy/source/tascam-util
sh ./.env/bin/activate
python3 tascam-util.py route -d LINE12 -s MIX
python3 tascam-util.py route -d LINE34 -s OUT34
popd


