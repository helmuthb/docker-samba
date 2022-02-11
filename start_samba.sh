#!/bin/sh

#Create users
#USERS='name1|password1|[folder1][|uid1] name2|password2|[folder2][|uid2]'
#may be:
# user|password foo|bar|/home/foo
#OR
# user|password|/home/user/dir|10000
#OR
# user|password||10000

if [ -z "$USERS" ]; then
  USERS="user|password"
fi

for i in $USERS ; do
    NAME=$(echo $i | cut -d'|' -f1)
    PASS=$(echo $i | cut -d'|' -f2)
  FOLDER=$(echo $i | cut -d'|' -f3)
     UID=$(echo $i | cut -d'|' -f4)

  if [ -z "$FOLDER" ]; then
    FOLDER="/home/$NAME"
  fi

  if [ ! -z "$UID" ]; then
    UID_OPT="-u $UID"
  fi

  echo -e "$PASS\n$PASS" | adduser -h $FOLDER -s /sbin/nologin $UID_OPT $NAME
  echo -e "$PASS\n$PASS" | smbpasswd -s -c /etc/samba/smb.conf -a $NAME
  mkdir -p $FOLDER
  chown $NAME:$NAME $FOLDER
  unset NAME PASS FOLDER UID
done

# Adjust samba config file
sed -e "s/#WORKGROUP#/$WORKGROUP/" -i /etc/smb.conf
sed -e "s/#NAME#/$NAME/" -i /etc/smb.conf

# Add folders in /mnt to samba config
for FOLDER in `ls /mnt`; do
  if [ -d "/mnt/$FOLDER" ]; then
    echo >> /etc/smb.conf
    echo "[$FOLDER]" >> /etc/smb.conf
    echo "comment = $FOLDER" >> /etc/smb.conf
    echo "path = /mnt/$FOLDER" >> /etc/smb.conf
    echo "read only = No" >> /etc/smb.conf
  fi
done

# Used to run custom commands inside container
if [ ! -z "$1" ]; then
  exec "$@"
else
  nmbd --no-process-group --log-stdout
  exec smbd --foreground --no-process-group --log-stdout
fi

