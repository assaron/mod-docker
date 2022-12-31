#!/bin/bash

# groupadd -f -g $GROUP_ID $GROUP_NAME \
# 	&& useradd -m -g $GROUP_ID -G audio -u $USER_ID $USER_NAME || true  \
# 	# && ls -lah ~/mod-ui \
# 	# && /mod/mod-ui/wait-for-it.sh mod-host:5555 \
# 	# && echo ${MOD_LIVE_ISO}docke \
# 	&& gosu ${USER_NAME} mod-host -p 5555 -f 5556 \
# 	&& gosu ${USER_NAME} python3 /mod/mod-ui/server.py
# 

set -e



export JACK_NO_AUDIO_RESERVATION=1 
gosu $MOD_USER:audio jackd --realtime -P 50 -d alsa $JACK_OPTIONS &
JACKD_PID=$!

sleep 2

gosu $MOD_USER:audio mod-host -p 5555 -f 5556 -v -n &
MODHOST_PID=$!

gosu $MOD_USER:audio bash -c "HOME=/mod python3 /mod/mod-ui/server.py" |& /watcher.py -t 7200 $JACKD_PID $MODHOST_PID



