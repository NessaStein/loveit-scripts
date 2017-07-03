#!/bin/bash
# Author NeSsA
# usage1: for i in `echo 20170626/*.txt`;do ./new_pv_uv.sh $i;done;
# rm -f /tmp/aaa.txt && for i in `echo 20170626/*.txt`;do ./new_pv_uv.sh $i | tee -a /tmp/aaa.txt;done; 之后手工处理aaa.txt

file=$1

name=$(echo ${file}|cut -d_ -f1 |cut -d/ -f2)

# 使用$()获取执行结果，解决了正则表达式转意的问题

echo "${name}_pv+uv"
for i in $(gawk -F'\\(,#\\)' '!a[$5]++{print $5}' ${file});do gawk -F'\\(,#\\)' '$5=="'$i'"{pv+=$6;uv+=$7}END{print "'$i'#" pv "#" uv}' ${file};done

# 统计空的
gawk -F'\\(,#\\)' '$5==""{pv+=$6;uv+=$7}END{print "NULL#" pv "#" uv}' ${file}
echo ""
