#! /bin/sh
# Simple wrapper around pkg-config imitating libupsclient-config which is no
# longer available.

/usr/bin/pkg-config $1 libupsclient

