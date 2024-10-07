#!/bin/bash
#
# this script takes the build.md instructions from https://github.com/mikebrady/shairport-sync and rolls it into a single script.  repositories are going to be cloned in the running user's home folder, git is obviously required.  This script assumes the OS is Debian/Ubuntu/apt based.

# install dependencies
cd ~
apt update
apt upgrade
apt install --no-install-recommends build-essential git autoconf automake libtool libpopt-dev libconfig-dev libasound2-dev avahi-daemon libavahi-client-dev libssl-dev libsoxr-dev libplist-dev libsodium-dev libavutil-dev libavcodec-dev libavformat-dev uuid-dev libgcrypt-dev xxd

# install nqptp
git clone https://github.com/mikebrady/nqptp.git
cd nqptp
autoreconf -fi
./configure --with-systemd-startup
make
make install

systemctl enable nqptp
systemctl start nqptp

# install shairport-sync
cd ~
git clone https://github.com/mikebrady/shairport-sync.git
cd shairport-sync
autoreconf -fi
./configure --sysconfdir=/etc --with-alsa --with-soxr --with-avahi --with-ssl=openssl --with-systemd --with-airplay-2
make
make install

# test before starting service with the below
# systemctl enable shairport-sync
# systemctl start shairport-sync
