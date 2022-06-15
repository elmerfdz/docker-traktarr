# hadolint ignore=DL3006,DL3007 
FROM eafxx/alpine-python
LABEL MAINTAINER="eafxx"

ENV \
  APP_DIR=traktarr \
  TRAKTARR_CONFIG=/config/config.json \
  TRAKTARR_LOGFILE=/config/traktarr.log \
  TZ=""

# add local files
COPY root/ /

# Install packages
SHELL ["/bin/ash", "-eo", "pipefail", "-c"]
# hadolint ignore=DL3018,DL3003,DL3013
RUN \
    chmod +x /etc/s6/init/init-stage2 && \
    chmod +x /docker-mods && \
    apk update && apk add --no-cache curl py3-setuptools tzdata && \
    if [ ! -e /usr/bin/python ]; then ln -sf python3 /usr/bin/python ; fi && \
    pip3 install --no-cache-dir --upgrade pip setuptools && \
    if [ ! -e /usr/bin/pip ]; then ln -s pip3 /usr/bin/pip ; fi && \
    bash /etc/cont-init.d/30-install

# Change directory
WORKDIR /${APP_DIR}

# Config volume
VOLUME /config