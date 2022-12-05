#!/bin/bash

temp=/root/temp
archives=/root/archives
number_package=1

for i in $@;do

  echo $i
  apt install -y $i --download-only > $temp

  for j in $(grep "Get:" $temp |awk '{print $5}');
  do

    package_name="$(ls /var/cache/apt/archives/$j*deb|cut -d"/" -f6)"
    package_name="$(echo $package_name|cut -d" " -f1)"
    if [[ $number_package -lt 10 ]];then
      string_number_package=0"$number_package"_
      mv /var/cache/apt/archives/$package_name /var/cache/apt/archives/$string_number_package$package_name
    else
      string_number_package="$number_package"_
      mv /var/cache/apt/archives/$package_name /var/cache/apt/archives/$string_number_package$package_name
    fi

  number_package=$((number_package + 1))

  done

  mkdir -p $archives/$i
  mv /var/cache/apt/archives/*deb $archives/$i/.
  rm -f $temp

done
