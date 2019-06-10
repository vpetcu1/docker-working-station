#!/bin/bash
if [ ! -f /.root_pw_set ]; then
	sh set_root_pw.sh
fi
if [ ! -f /.user_pw_set ]; then
	sh set_user_pw.sh
fi
sh permissions.sh
sh clean_up.sh
