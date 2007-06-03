#!/bin/bash
#
# collectd	Initscript for collectd
#		http://collectd.org/
# Authors:	Florian Forster <octo@verplant.org>
#		Sebastian Harl <sh@tokkee.org>
#

### BEGIN INIT INFO
# Provides:          collectd
# Required-Start:    $local_fs $remote_fs
# Required-Stop:     $local_fs $remote_fs
# Should-Start:      $network $named $syslog $time
# Should-Stop:       $network $named $syslog
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: start the statistics collection daemon
### END INIT INFO

set -e

PATH=/sbin:/bin:/usr/sbin:/usr/bin
DESC="statistics collection daemon"
NAME=collectd
DAEMON=/usr/sbin/$NAME
SCRIPTNAME=/etc/init.d/$NAME
ARGS=""

CONFIGFILE=/etc/collectd/collectd.conf

# Gracefully exit if the package has been removed.
test -x $DAEMON || exit 0

if [ -r /etc/default/$NAME ]; then
	. /etc/default/$NAME
fi

d_start() {
	if [ -f "$CONFIGFILE" ]; then
		$DAEMON -C $CONFIGFILE 2> /dev/null
	else
		echo ""
		echo "This package is not configured yet. Please refer"
		echo "to /usr/share/doc/collectd/README.Debian for"
		echo "details."
		echo ""
		exit 0
	fi
}

d_stop() {
	start-stop-daemon --stop --quiet --oknodo --exec $DAEMON
}

case "$1" in
	start)
		echo -n "Starting $DESC: $NAME"
		d_start
		echo "."
		;;
	stop)
		echo -n "Stopping $DESC: $NAME"
		d_stop
		echo "."
		;;
	restart|force-reload)
		echo -n "Restarting $DESC: $NAME"
		d_stop
		sleep 1
		d_start
		echo "."
		;;
	*)
		echo "Usage: $SCRIPTNAME {start|stop|restart|force-reload}" >&2
		exit 1
		;;
esac

exit 0

# vim: syntax=sh noexpandtab sw=4 ts=4 :
