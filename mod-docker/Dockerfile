FROM ubuntu
ENV REBUILD=true
ENV DEBIAN_FRONTEND=noninteractive

# Install dependemcies
RUN apt-get update && apt-get install -q -y wget 

# Add KX Studio Repo, install plugins
RUN dpkg --purge kxstudio-repos-gcc5
RUN wget https://launchpad.net/~kxstudio-debian/+archive/kxstudio/+files/kxstudio-repos_10.0.3_all.deb
RUN dpkg -i kxstudio-repos_10.0.3_all.deb
RUN apt-get update && apt-get install -y --no-install-recommends \
	jackd2 git liblilv-dev libreadline-dev lilv-utils libjack-jackd2-dev python3

# Build mod-host
RUN git clone https://github.com/moddevices/mod-host.git /mod/mod-host/source
RUN apt install build-essential -y --no-install-recommends
RUN make -C /mod/mod-host/source && make install -C  /mod/mod-host/source

# Install LV2 Plugins from MOD Repo (to extract modgui data)
RUN apt-get update && apt-get install -y --no-install-recommends kxstudio-meta-audio-plugins kxstudio-meta-audio-plugins-lv2 
RUN git clone https://github.com/moddevices/mod-lv2-data.git /mod/mod-host/mod-lv2-data
RUN echo
COPY ./copy_modguis.sh /mod/mod-host
RUN chmod +x /mod/mod-host/copy_modguis.sh && bash -c  '/mod/mod-host/copy_modguis.sh' && echo

# Install dependencies
RUN apt-get update \
	&& apt-get -y install --no-install-recommends python3-pip python3-dev python3-venv python3-setuptools git build-essential libasound2-dev libjack-jackd2-dev liblilv-dev libjpeg-dev zlib1g-dev wget curl \	
	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/man/?? /usr/share/man/??_*

# Build mod-ui
RUN git clone https://github.com/moddevices/mod-ui.git /mod/mod-ui
RUN pip3 install -r /mod/mod-ui/requirements.txt
RUN make -C /mod/mod-ui/utils 
RUN chown :audio -R /mod/mod-ui && chmod -R 775 /mod/mod-ui
RUN wget https://raw.githubusercontent.com/vishnubob/wait-for-it/master/wait-for-it.sh -P /mod/mod-ui && chmod +x /mod/mod-ui/wait-for-it.sh

# workaround for making old tornado python3.10 compatible:
RUN  sed -i -e 's/collections.MutableMapping/collections.abc.MutableMapping/' \
        /usr/local/lib/python3.10/dist-packages/tornado/httputil.py

# set up mod-ui
ENV MOD_DEV_ENVIRONMENT=0 
ENV USE_STANDARD_JACK_OUTPUTS = 1
ENV MOD_HOST_ADDR="localhost"
RUN chown :audio -R /mod/mod-ui && chmod -R 775 /mod/mod-ui


COPY docker_entrypoint.sh /

CMD /docker_entrypoint.sh 

# # install gosu for a better su+exec command
# ARG GOSU_VERSION=1.12
# RUN dpkgArch="$(dpkg --print-architecture | awk -F- '{ print $NF }')" \
# 	&& wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch" \
# 	&& chmod +x /usr/local/bin/gosu \
# 	&& gosu nobody true 
# 
# 
# # Run mod host
# # Generate user same as host . (It will need to connect to host jack with same username)
# CMD echo ${USER_NAME} && echo ${GROUP_NAME} \ 
# 	&& groupadd -f $GROUP_ID \
# 	&& useradd -m -g $GROUP_ID -G audio -u $USER_ID $USER_NAME || true  \
# 	# && rsync /mod/mod/* -rElu /mod/${USER_NAME} \ 
# 	# && chown -R ${USER_NAME}:${GROUP_ID} /home/${USER_NAME} \
# 	# && ls -la /usr/lib/lv2 \
# 	# && /bin/bash 
# 	&& gosu ${USER_NAME} mod-host -v -n -p 5555
