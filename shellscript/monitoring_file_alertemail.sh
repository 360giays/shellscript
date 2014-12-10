#!/bin/sh
Thishost=$(hostname)

while read linemd5sum
    do
        getfilename_2=$(echo $linemd5sum | awk -F ' ' '{print $2}')
        getmd5_2=$(echo $linemd5sum | awk -F ' ' '{print $1}')

#Find files in directory and hash this file
        listfile=$(find /opt/sap/config/ -type f)
#Lookup files and hash
        for listfileresult in $listfile
        do
                hashfile=$(md5sum $listfileresult)
                getmd5_1=$(echo $hashfile | awk -F ' ' '{print $1}')
                getfilename_1=$(echo $hashfile | awk -F ' ' '{print $2}')
                        if [ $getfilename_2 == $getfilename_1 ];then
                                if [ $getmd5_2 != $getmd5_1 ];then
                                        echo "$getfilename_2 was change" | mail -s "$Thishost File was change" operations.team.social.intelligence@sdl.com
                                fi
                        fi

        done
     done < /usr/local/src/md5sum_config.txt

find /opt/sap/config/ -type f -print0 | xargs -0 md5sum > /usr/local/src/md5sum_config.txt