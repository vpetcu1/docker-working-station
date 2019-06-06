echo "Change owner to folder work to $REMOTE_USER"
chown $REMOTE_USER:$REMOTE_USER -R /home/$REMOTE_USER/
exit 0