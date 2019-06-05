#!/bin/bash
if [ ! -f /.root_pw_set ]; then
	/set_root_pw.sh
fi
if [ ! -f /.user_pw_set ]; then
	/set_user_pw.sh
fi
exec /usr/bin/supervisord -n -c /etc/supervisor/supervisord.conf 1>/dev/null
/clean_up.sh