#!/bin/sh
CONF=/etc/config/qpkg.conf
QPKG_NAME="Headphones"
QPKG_INSTALL_PATH=`/sbin/getcfg $QPKG_NAME Install_Path -f ${CONF}`
QPKG_ROOT=`/sbin/getcfg $QPKG_NAME Qpkg_Root -f ${CONF}`
APACHE_ROOT=/share/`/sbin/getcfg SHARE_DEF defWeb -d Qweb -f /etc/config/def_share.info`
PYTHON=`which python`
case "$1" in
  start)
    ENABLED=$(/sbin/getcfg $QPKG_NAME Enable -u -d FALSE -f $CONF)
    if [ "$ENABLED" != "TRUE" ]; then
        echo "$QPKG_NAME is disabled."
        exit 1
    fi

    $PYTHON $QPKG_INSTALL_PATH/headphones/Headphones.py --quiet --daemon --nolaunch --pidfile=/var/run/headphones.pid --datadir=$QPKG_ROOT/Headphones-data/ --config=$QPKG_ROOT/Headphones-data/config.ini

    : ADD START ACTIONS HERE
    ;;

  stop)
    kill -9 $(cat /var/run/headphones.pid)
    rm /var/run/headphones.pid

    : ADD STOP ACTIONS HERE
    ;;

  restart)
    $0 stop
    $0 start
    ;;

  *)
    echo "Usage: $0 {start|stop|restart}"
    exit 1
esac

exit 0
