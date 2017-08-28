#!/bin/sh 

FILE=$(date +%Y%m)
#合计pv
echo 'month-day,HQHY-pv,MangoTV-pv,VOOLE-pv,HSWJ-pv,NULL-pv,allsum,HQHY_PV_zhanbi,MangoTV_PV_zhanbi,VOOLE_PV_zhanbi,HSWJ_PV_zhanbi,NULL_PV_zhanbi,' > /var/www/html/account/pv_${FILE}.csv
for i in $(ls /var/www/html/pv/pv_`date +%Y%m`*)
do
echo $i|awk -F[_.] '{printf $2","}'
grep sum $i|sed 's/sum,//g';
done>/tmp/month_pv.txt

#计算cp合计，占比
awk -F, '{SUM=($2+$3+$4+$5+$6);printf $0 SUM "," 100*($2/SUM) "%," 100*($3/SUM) "%," 100*($4/SUM) "%," 100*($5/SUM) "%," 100*($6/SUM) "%,\n"}' /tmp/month_pv.txt >>/var/www/html/account/pv_${FILE}.csv
