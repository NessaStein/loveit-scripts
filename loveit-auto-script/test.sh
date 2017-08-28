#!/bin/bash

for i in $(ls *_play_logs*.txt);do awk -F'\\(,#\\)' '$5=="HQHY"{pv+=$6;uv+=$7}END{print "'$i'#HQHY#" pv "#" uv}' $i;awk -F'\\(,#\\)' '$5=="MangoTV"{pv+=$6;uv+=$7}END{print "'$i'#MangoTV#" pv "#" uv}' $i;awk -F'\\(,#\\)' '$5=="VOOLE"{pv+=$6;uv+=$7}END{print "'$i'#VOOLE#" pv "#" uv}' $i;awk -F'\\(,#\\)' '$5=="HSWJ"{pv+=$6;uv+=$7}END{print "'$i'#HSWJ#" pv "#" uv}' $i;awk -F'\\(,#\\)' '$5==""{pv+=$6;uv+=$7}END{print "'$i'#NULL#" pv "#" uv}' $i;done | tee aggregation.txt

#第二步：地州名字规范化清洗
sed -i 's/_play_logs.*.txt//g' aggregation.txt
#第三部：生成pv报表
echo "sheet1"
echo "地州名称/页面点击(pv)#HQHY#MangoTV#VOOLE#HSWL#NULL";for i in $(echo "BANNA" "BAOSHAN" "CHUXIONG" "DALI" "DEHONG" "DIQING" "HONGHE" "KUNMING" "LIJIANG" "LINCANG" "NUJIANG" "PUER" "QUJING" "WENSHAN" "YUXI" "ZHAOTONG");do echo -n $i"#"; awk -F'#' '/'$i'/{ORS="";print $3"#"}END{print "\n"}' aggregation.txt;done
#第四步：生成uv报表
echo "sheet2"
echo "地州名称/用户点击(uv)#HQHY#MangoTV#VOOLE#HSWL#NULL";for i in $(echo "BANNA" "BAOSHAN" "CHUXIONG" "DALI" "DEHONG" "DIQING" "HONGHE" "KUNMING" "LIJIANG" "LINCANG" "NUJIANG" "PUER" "QUJING" "WENSHAN" "YUXI" "ZHAOTONG");do echo -n $i"#"; awk -F'#' '/'$i'/{ORS="";print $4"#"}END{print "\n"}' aggregation.txt;done
#第五步：生成表三，统计各个cp的pv,uv总和，占比由exel自动得出
#1. 各个cp，pv总和
echo "sheet3 pv"
for i in $(echo "HQHY" "MangoTV" "VOOLE" "HSWJ" "NULL");do awk -F"#" '$2=="'$i'"{sum+=$3}END{print sum}' aggregation.txt;done
#2.各个cp，uv总和
echo "sheet3 uv"
for i in $(echo "HQHY" "MangoTV" "VOOLE" "HSWJ" "NULL");do awk -F"#" '$2=="'$i'"{sum+=$4}END{print sum}' aggregation.txt;done
