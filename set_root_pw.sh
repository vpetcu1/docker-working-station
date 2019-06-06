#!/bin/bash

if [ -f /.root_pw_set ]; then
	echo  "Root password already set!"
	exit 0
fi

echo "=> Setting password to the root user"
echo "root:$REMOTE_PASSWORD" | chpasswd
echo "=> Done!"
touch /.root_pw_set

echo "========================================================================"
echo "You can now connect to this working-station container via SSH using:"
echo ""
echo "    ssh -p <port> root@<host>"
echo "and enter the root password $REMOTE_PASSWORD when prompted"
echo "========================================================================"
exit 0