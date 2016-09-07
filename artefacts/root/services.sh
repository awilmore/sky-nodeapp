#!/bin/sh

##
# NOTE
#  All scripts inside /root/startup/ folder are executed using this
#  before running to supervisord.
#  To have tomcat, for example, initialise on startup, create a
#  /etc/supervisor/conf.d/tomcat.conf configuration file with
#  the supervisord paramaters required to start the tomcat service.
##

set -e

# Execute all startup scripts
for file in `ls /root/startup/*.sh`
do
  echo "Executing file ${file}..."
  /bin/bash $file
done

# Start supervisor service
echo " "
echo " .............................................................. "
echo " ...                                                        ... "
echo " ...               STARTING SUPERVISORD...                  ... "
echo " ...                                                        ... "
echo " .............................................................. "
echo " "

# Start rsyslog
service rsyslog start

# Start supervisor
/usr/bin/supervisord &

# Tail logs
tail -f /var/log/nodeapp/*

# Start sleeper service to catch supervisor exit (for development)
if [ -f "/root/services/sleep-forever.sh" ]; then
  echo " "
  echo " !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! "
  echo " !!!                                                        !!! "
  echo " !!!                 SUPERVISORD STOPPED!                   !!! "
  echo " !!!                                                        !!! "
  echo " !!! Please note - this script has gone into a loop in      !!! "
  echo " !!! order to keep the bash process alive and the docker    !!! "
  echo " !!! container running. This is useful for developers       !!! "
  echo " !!! wanting to test and restart things via supervisord     !!! "
  echo " !!! in the container, however this should probably be      !!! "
  echo " !!! removed for production containers (although it         !!! "
  echo " !!! hurt).                                                 !!! "
  echo " !!!                                                        !!! "
  echo " !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! "
  echo " "
  /root/services/sleep-forever.sh
fi
