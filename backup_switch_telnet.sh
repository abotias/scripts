#!/bin/sh
for i in 89 87 182 184 124
do
( echo open 10.0.$i.1
sleep 1
echo admin
sleep 1
echo <PASSWORD>
sleep 5
echo "enable"
sleep 1
echo "copy startup-config tftp <remote_server>/10.0.$i.1.cfg"
sleep 5
echo exit
sleep 2
  ) | telnet >> backup_out.log
done


for i in 8 10
do
( echo open 10.0.0.$i
sleep 1
echo admin
sleep 1
echo <PASSWORD>
sleep 5
echo "copy startup-config tftp <remote_server> 10.0.0.$i.cfg"
sleep 5
echo exit
sleep 2
  ) | telnet >> backup_other_switch.log
done
