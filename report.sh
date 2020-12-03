#!/bin/bash

USER="me"

# Report - can be called separately

printf "\n\033[1m\033[33mPost-Install Report\n"

## Show Local IP

printf "\nLocal IP addresses -\n"
ip -4 addr show | grep -oP '(?<=inet\s)\d+(\.\d+){3}'

## Show Remote IP

printf "\nRemote (public) IP address -\n"
wget -qO - icanhazip.com

## Show Gateway

printf "\nGateway addresses -\n"
ip r | grep default

## Show DNS

printf "\nDNS addresses -\n"
grep "nameserver" /etc/resolv.conf

## Show Temp Hostname / Intranet connection file name

printf "\nLocal Hostname\n" # expected jc-AUTOSSHPORT
hostname

## Show AutoSSH & Zabbix Ports

printf "\nAutoSSH & Zabbix Ports\n"
cat /home/$USER/install/openportlist.txt

## Notes

printf "\nNo Local IP = not connected to the network\n"
echo "No Remote IP = not connected to the Internet"
echo "No Ports = Couldn't contact the Target"

tput sgr0