# ReverseSSH first setup

# Run as root

yum install -y autossh

# Prep - Install findopenport on Target host
# & copy Target .pem & .pub keys to $USER/install

# Set user & userdir

USER="me"
TARGET="target.host.net"

# Creating installs folder

mkdir $USER/install

# Log output & errors

exec > /home/$USER/install/setup.log 2>&1

## Create local SSH key

su $USER -c 'cat /dev/zero | ssh-keygen -q -N ""'

## Copy Local host key to Target - presumes the same user is there (change if not)

cat /home/$USER/.ssh/id_rsa.pub | ssh -i /home/$USER/install/$USER.pem $USER@$TARGET "cat >> /home/$USER/.ssh/authorized_keys"

## Copy Target key to Local host

touch /home/$USER/.ssh/authorized_keys
chmod 644 /home/$USER/.ssh/authorized_keys
chown $USER:$USER /home/$USER/.ssh/authorized_keys
cat /home/$USER/install/$USER.pub > /home/$USER/.ssh/authorized_keys

## Find free ports on Target & output to install file

ssh -i /home/$USER/install/$USER.pem $USER@$TARGET 'findopenport 2>/dev/null' >
/home/$USER/install/openportlist.txt
readarray -t remote_port < /home/$USER/install/openportlist.txt

# Set temporary hostname

hostnamectl set-hostname "build-${remote_port[0]}"

## Set host AutoSSH port in user crontab

echo "@reboot nohup /usr/bin/autossh -M 0 -o 'ServerAliveInterval 10' -o 'ServerAliveCountMax 3' -NR ${remote_port[0]}:localhost:22 $USER@$TARGET &" >> /var/spool/cron/crontabs/$USER

## Create local host connection file & copy it to Target - presumes same username (change if needed)

echo "ssh -p ${remote_port[0]} $USER@127.0.0.1" > /home/$USER/install/build-${remote_port[0]}.sh
scp -i /home/$USER/install/$USER.pem /home/$USER/install/build-${remote_port[0]}.sh
$USER@$TARGET:/home/$USER/

## Start Reverse Proxy connection

nohup /usr/bin/autossh -M 0 -o "ServerAliveInterval 10" -o "ServerAliveCountMax 3" -NR ${remote_port[0]}:localhost:22 $USER@$TARGET &

# Now on the Target you can connect using the host connection file - eg. ./build-###
