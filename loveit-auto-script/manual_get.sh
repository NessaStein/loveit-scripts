#!/bin/sh 

# ftp download 1 days ago 
#FILE=$(date -d "1 days ago" +%Y%m%d)
FILE=$1
echo "ymd is $FILE"

wget -nH -m --ftp-user=ftpuser3 --ftp-password=ftpuser3 ftp://172.25.20.151/$FILE
echo "done"

cd $FILE
# data clean and get csv

for i in $(ls *_play_logs*.txt);do awk -F'\\(,#\\)' '$5=="HQHY"{pv+=$6;uv+=$7}END{print "'$i'#HQHY#" pv "#" uv}' $i;awk -F'\\(,#\\)' '$5=="MangoTV"{pv+=$6;uv+=$7}END{print "'$i'#MangoTV#" pv "#" uv}' $i;awk -F'\\(,#\\)' '$5=="VOOLE"{pv+=$6;uv+=$7}END{print "'$i'#VOOLE#" pv "#" uv}' $i;awk -F'\\(,#\\)' '$5=="HSWJ"{pv+=$6;uv+=$7}END{print "'$i'#HSWJ#" pv "#" uv}' $i;awk -F'\\(,#\\)' '$5==""{pv+=$6;uv+=$7}END{print "'$i'#NULL#" pv "#" uv}' $i;done | tee aggregation.txt

#第二步：地州名字规范化清洗
sed -i 's/_play_logs.*.txt//g' aggregation.txt
#第三部：生成pv报表
echo "city/pv,HQHY,MangoTV,VOOLE,HSWL,NULL">/var/www/html/pv/pv_${FILE}.csv;for i in $(echo "BANNA" "BAOSHAN" "CHUXIONG" "DALI" "DEHONG" "DIQING" "HONGHE" "KUNMING" "LIJIANG" "LINCANG" "NUJIANG" "PUER" "QUJING" "WENSHAN" "YUXI" "ZHAOTONG");do echo -n $i","; awk -F'#' '/'$i'/{ORS="";print $3","}END{print "\n"}' aggregation.txt;done>>/var/www/html/pv/pv_${FILE}.csv

# sumup pv
for i in $(echo "HQHY" "MangoTV" "VOOLE" "HSWJ" "NULL");do awk -F"#" '$2=="'$i'"{sum+=$3}END{print sum}' aggregation.txt;done> /tmp/a.txt

echo -n "sum," >>/var/www/html/pv/pv_${FILE}.csv;for i in `cat /tmp/a.txt`;do echo -n $i",";done >>/var/www/html/pv/pv_${FILE}.csv

#第四部：生成uv报表
echo "city/uv,HQHY,MangoTV,VOOLE,HSWL,NULL">/var/www/html/uv/uv_${FILE}.csv;for i in $(echo "BANNA" "BAOSHAN" "CHUXIONG" "DALI" "DEHONG" "DIQING" "HONGHE" "KUNMING" "LIJIANG" "LINCANG" "NUJIANG" "PUER" "QUJING" "WENSHAN" "YUXI" "ZHAOTONG");do echo -n $i","; awk -F'#' '/'$i'/{ORS="";print $4","}END{print "\n"}' aggregation.txt;done>>/var/www/html/uv/uv_${FILE}.csv

# sumup uv
for i in $(echo "HQHY" "MangoTV" "VOOLE" "HSWJ" "NULL");do awk -F"#" '$2=="'$i'"{sum+=$4}END{print sum}' aggregation.txt;done> /tmp/a.txt

echo -n "sum," >>/var/www/html/uv/uv_${FILE}.csv;for i in `cat /tmp/a.txt`;do echo -n $i",";done >>/var/www/html/uv/uv_${FILE}.csv
