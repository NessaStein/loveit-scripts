#!/bin/sh 

echo "parameter YearonMonth"
FILE=$1
#合计uv
echo 'month-day,HQHY-uv,MangoTV-uv,VOOLE-uv,HSWJ-uv,NULL-uv,allsum,HQHY_UV_zhanbi,MangoTV_UV_zhanbi,VOOLE_UV_zhanbi,HSWJ_UV_zhanbi,NULL_UV_zhanbi,' > /var/www/html/account/uv_${FILE}.csv
for i in $(ls /var/www/html/uv/uv_${FILE}*)
do
echo $i|awk -F[_.] '{printf $2","}'
grep sum $i|sed 's/sum,//g';
done>/tmp/month_uv.txt

#计算cp合计，占比
awk -F, '{SUM=($2+$3+$4+$5+$6);printf $0 SUM "," 100*($2/SUM) "%," 100*($3/SUM) "%," 100*($4/SUM) "%," 100*($5/SUM) "%," 100*($6/SUM) "%,\n"}' /tmp/month_uv.txt >>/var/www/html/account/uv_${FILE}.csv
