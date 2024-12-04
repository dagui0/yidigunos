#!/bin/sh

# target system mount point
LFS=/mnt/lfs

# target system triplet
LFS_TGT=x86_64-yidigunos-linux-gnu

# turns off bash's hash function. PATH will not cached.
set +h

# file-creation mask. new dir/file's perm mode will be set to 0755 or 0644.
umask 022

# set to default locale
LC_ALL=POSIX

# set $LFS/tools/bin should be the first item of $PATH
PATH=/usr/bin:${HOME}/bin
if [ ! -L /bin ]; then
    PATH=/bin:${PATH}
fi
PATH=${LFS}/tools/bin:${PATH}

# configure script settings.
# override it to prevent potential contamination from the host.
CONFIG_SITE=${LFS}/usr/share/config.site

export LFS LC_ALL LFS_TGT PATH CONFIG_SITE
