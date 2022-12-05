#!/bin/bash

#variables
servicio="nginx"
puerto=":80"


#consulta sistema
cpuusage=`ps -eo %cpu  | awk '{sum += $1} END {print sum}'`
memoryusage=`ps -eo %mem  | awk '{sum += $1} END {print sum}'`
memoryswapusage=`free | grep Swap | awk '{printf "%.2f\n", $3/$2*100}' 2>/dev/null`
[[ -z "$memoryswapusage" ]] && memoryswapusage="0"

sistema="`date +%Y-%m-%d_%H:%M`;$cpuusage;$memoryusage;$memoryswapusage"

if [ -z "$servicio" ]
then
        echo $sistema
else
        #consulta servicio
        cpuusageservicio=`ps u -C $servicio | awk '{sum += $3} END {print sum}'`
        memusageservicio=`ps u -C $servicio | awk '{sum += $4} END {print sum}'`
        conexiones=`netstat -an|grep $puerto|grep ESTABLISHED|awk '{print $5}'|grep -v grep|grep -v $puerto|wc -l`
        echo "$sistema;$cpuusageservicio;$memusageservicio;$conexiones"
fi
