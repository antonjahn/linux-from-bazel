#!/usr/bin/env bash
# For lack of a better name: mock docker with a simple shell script > mocker.sh
# This script takes one argument: the rootfs.tar that is extracted and entered

# set -euo pipefail
# set -x

export LFS="/tmp/lfs"
rm -rf $LFS
mkdir -pv $LFS
tar -xvf $1 -C $LFS

bwrap --bind $LFS / --dev /dev --proc /proc --tmpfs /run --unshare-all /usr/bin/env -i \
    HOME=/root \
    TERM="$TERM" \
    PS1='(lfs chroot) \u:\w\$ ' \
    PATH=/usr/bin:/usr/sbin \
    MAKEFLAGS="-j$(nproc)" \
    TESTSUITEFLAGS="-j$(nproc)" \
    bash --login
