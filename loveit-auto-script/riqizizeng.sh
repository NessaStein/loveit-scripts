#!/bin/sh
#riqizizeng
datebeg=$1
dateend=$2
#read datebeg
#read dateend
beg_s=`date -d "$datebeg" +%s`
end_s=`date -d "$dateend" +%s`
while [ "$beg_s" -le "$end_s" ]
do
date -d @$beg_s +"%Y%m%d"
beg_s=$((beg_s+86400))
done
