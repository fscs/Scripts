#!/bin/bash
DD_PARAMETERS="bs=4M"
if [ $# != 2 ]; then
        echo "$0 StickName Image"
        echo "Es muss der Name der Sticks angegeben werden und der Pfad zum Image"
        echo "Mögliche Namen:"
        echo "$(ls /dev/disk/by-id | grep usb | grep -v part | cut -d'-' -f2 | cut -d'_' -f1 | uniq)"
else
        for i in $(ls /dev/disk/by-id | grep $1 | grep -v part); do 
                DEVICE=$(readlink -e /dev/disk/by-id/$i)
                dd if=$2 of=$DEVICE $DD_PARAMETERS &
        done
        echo "DD started"
        while [ $(pidof dd | wc -l) -gt 0 ]
        do
                sleep 1
        done
        echo "Syncing"
        sync
        echo "Done";
        beep -f 250  -l 300  -r 2
fi
