#!/bin/bash
# Author NeSsA

file=$1

# 使用$()获取执行结果，解决了正则表达式转意的问题，同时统计cp为空的pv和uv

for i in $(gawk -F'\\(,#\\)' '!a[$5]++{print $5}' ${file});do gawk -F'\\(,#\\)' '$5=="'$i'"{pv+=$6;uv+=$7}END{print "'$i'", pv, uv}' ${file};done
