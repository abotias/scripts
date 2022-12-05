#!/bin/bash
#Get which user is running the service
for i in $(systemctl --type=service --state=running|awk 'NR>1'|awk '{print $1}'|head -n-5);do
  systemctl show -pId,User $i | sed -z 's/\n/;/g'|awk -F";" '{if ($1 == "User=") {print "User=root;"$2} else {print $1";"$2}}'
done
