#!/bin/bash

if [ -f /.root_pw_set ]; then
	echo  "Root password already set!"
	exit 0
fi

PASS=${ROOT_PASS:-$(pwgen -s 12 1)}
echo "=> Setting password to the root user"
echo "root:$PASS" | chpasswd
echo "=> Done!"
touch /.root_pw_set

echo "========================================================================"
echo "You can now connect to this Ubuntu container via SSH using:"
echo ""
echo "    ssh -p <port> root@<host>"
echo "and enter the root password $PASS when prompted"
echo "========================================================================"
