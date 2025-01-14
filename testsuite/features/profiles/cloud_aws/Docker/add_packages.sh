#!/bin/bash
set -e

# temporarily disable non-working repo
zypper mr --disable Fake-RPM-SLES-Channel || :
zypper --non-interactive --gpg-auto-import-keys ref

# install, configure, and start avahi
zypper --non-interactive in avahi
cp /root/avahi-daemon.conf /etc/avahi/avahi-daemon.conf
/usr/sbin/avahi-daemon -D

# re-enable normal repo and remove helper repo
zypper mr --enable Fake-RPM-SLES-Channel || :
zypper rr sles15sp4

# do the real test
zypper --non-interactive --gpg-auto-import-keys ref
zypper --non-interactive in aaa_base aaa_base-extras net-tools timezone vim less sudo tar gzip python3 python3-psutil

# kill avahi
/usr/sbin/avahi-daemon -k
