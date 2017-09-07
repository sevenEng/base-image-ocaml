FROM alpine:3.5

RUN apk update && apk upgrade &&\
    apk add sudo &&\
    adduser -S mebox &&\
    echo 'mebox ALL=(ALL:ALL) NOPASSWD:ALL' > /etc/sudoers.d/mebox &&\
    chmod 440 /etc/sudoers.d/mebox &&\
    chown root:root /etc/sudoers.d/mebox &&\
    sed -i.bak 's/^Defaults.*requiretty//g' /etc/sudoers

USER mebox
WORKDIR /home/mebox

RUN sudo apk update && sudo apk add \
    opam alpine-sdk bash ncurses-dev m4 perl autoconf linux-headers gmp-dev zlib-dev libsodium-dev libffi-dev

RUN opam init -y && opam update
ADD . .

RUN opam switch --alias-of=4.04.2 databox-bridge   && eval `opam config env` && opam switch import databox-bridge.install
RUN opam switch --alias-of=4.04.2 export-service   && eval `opam config env` && opam switch import export-service.install
RUN opam switch --alias-of=4.04.2 store-timeseries && eval `opam config env` && opam switch import store-timeseries.install
