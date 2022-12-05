#!/bin/sh
#v1.0

#VARS
volsrc="SRC"
voldst="DST"


function backup(){
  mkdir -p /vmfs/volumes/$voldst/$1_DR/
  cp /vmfs/volumes/$volsrc/$1/$1.vmx /vmfs/volumes/$voldst/$1_DR/$1.vmx
  cp /vmfs/volumes/$volsrc/$1/$1.nvram /vmfs/volumes/$voldst/$1_DR/$1.nvram
  cp /vmfs/volumes/$volsrc/$1/$1.vmsd /vmfs/volumes/$voldst/$1_DR/$1.vmsd
  vmid=$(vim-cmd vmsvc/getallvms | grep $1 | awk '{print $1}')
  vim-cmd vmsvc/snapshot.create $vmid backup 'Snapshot created by Backup Script' 0 0
  vmkfstools -i /vmfs/volumes/$volsrc/$1/$1.vmdk /vmfs/volumes/$voldst/$1_DR/$1.vmdk -d thin
  vim-cmd vmsvc/snapshot.removeall $vmid

}

function clone(){
  mkdir -p /vmfs/volumes/$volsrc/$2
  cp /vmfs/volumes/$volsrc/$1/$1.vmx /vmfs/volumes/$volsrc/$2/$2.vmx
  cp /vmfs/volumes/$volsrc/$1/$1.nvram /vmfs/volumes/$volsrc/$2/$2.nvram
  cp /vmfs/volumes/$volsrc/$1/$1.vmsd /vmfs/volumes/$volsrc/$2/$2.vmsd
  vmid=$(vim-cmd vmsvc/getallvms | grep $1 | awk '{print $1}')
  vim-cmd vmsvc/snapshot.create $vmid backup 'Snapshot created by Backup Script' 0 0
  vmkfstools -i /vmfs/volumes/$volsrc/$1/$1.vmdk /vmfs/volumes/$volsrc/$2/$2.vmdk -d thin
  vim-cmd vmsvc/snapshot.removeall $vmid
  sed -i "s/$1/$2/g" /vmfs/volumes/$volsrc/$2/$2.vmx
  vim-cmd solo/registervm /vmfs/volumes/$volsrc/$2/$2.vmx $2
}


if [ -z $volsrc ];then printf "PLEASE CHECK VAR SCRIPT\n";exit;fi
if [ -z $1  ];then  printf "\n###### Unknow option without argument"; printf "\nUsage: ./backup.sh [OPTIONS] \n -b | --b for backup\n --allbackup for backup all vm\n\n"; exit;fi


for i in "$@"; do
  case $i in
    -b |--backup)
      if [ -z $2 ];then printf "\n##### Please define VM name\n"; exit;fi
      if [ ! -d "/vmfs/volumes/$volsrc/$2" ];then printf "Virtual Machine not found.\n";exit;fi
      backup $2
      exit 1
      ;;
    --allbackup)
      for i in $(vim-cmd vmsvc/getallvms | awk 'NR>1{print $2}');do
      backup $i
      done
      exit 1
      ;;
    -c |--clone)
      if [ -z $2 ];then printf "\n##### Please define source VM name\n"; exit;fi
      if [ -z $3 ];then printf "\n##### Please define clone VM name\n"; exit;fi
      clone $2 $3
      exit 1
      ;;
    -*|--*)
      echo "Unknown option $i"
      exit 1
      ;;
    *)
      echo "Unknown option $i"
      exit 1
      ;;
  esac
done
