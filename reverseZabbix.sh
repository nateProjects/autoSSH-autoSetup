# Zabbix monitoring via reverse proxy

# Add this to the end of the reverseSSH.sh if needed
# This presumes the Zabbix agent is installed
# & the zabbix.pem is in the installs directory

SERVER="zabbix.server.net"

# Copy local SSH key to Zabbix server

cat /home/$USER/.ssh/id_rsa.pub | ssh -i /home/$USER/install/zabbix.pem zabbix@$SERVER "cat >>
/var/lib/zabbix/.ssh/authorized_keys"

## Add Zabbix reverse port number in crontab

echo "@reboot nohup /usr/bin/autossh -M 0 -o 'ServerAliveInterval 10' -o 'ServerAliveCountMax 3' -NR ${remote_port[1]}:127.0.0.1:10050 zabbix@$SERVER &" >> /var/spool/cron/crontabs/$USER

# Start Zabbix agent reverse proxy

nohup /usr/bin/autossh -M 0 -o "ServerAliveInterval 10" -o "ServerAliveCountMax 3" -NR ${remote_port[1]}:127.0.0.1:10050 zabbix@$SERVER &
