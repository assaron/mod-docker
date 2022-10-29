#!/bin/bash

# groupadd -f -g $GROUP_ID $GROUP_NAME \
# 	&& useradd -m -g $GROUP_ID -G audio -u $USER_ID $USER_NAME || true  \
# 	# && ls -lah ~/mod-ui \
# 	# && /mod/mod-ui/wait-for-it.sh mod-host:5555 \
# 	# && echo ${MOD_LIVE_ISO}docke \
# 	&& gosu ${USER_NAME} mod-host -p 5555 -f 5556 \
# 	&& gosu ${USER_NAME} python3 /mod/mod-ui/server.py
# 


export JACK_NO_AUDIO_RESERVATION=1 
jackd --realtime -P 50 -d alsa -n 3 --period 256 --device hw:USB --rate 96000 &

sleep 1

mod-host -p 5555 -f 5556 &

sleep 1

exec python3 /mod/mod-ui/server.py 	


