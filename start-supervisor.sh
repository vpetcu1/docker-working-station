#!/bin/bash
exec /usr/bin/supervisord -n -c /etc/supervisor/supervisord.conf 1>/dev/null