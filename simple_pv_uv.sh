#!/bin/bash
# Author NeSsA

# "用法：脚本+要处理的文本"

file=$1

# 统计输出cp，去重，过滤数字和NUll
#gawk -F, 'NR>1 && !a[$5]++{print "分类cp：" $5}' 点播统计_昆明_20170618.csv
gawk -F, 'NR>1 && !a[$5]++ && $5!~/^[0-9]+/ && $5!="NULL"{print $5}' ${file}

# 分别输出各个cp的pv以及uv 这里只输出HQHY
gawk -F, '$5=="HQHY"{pv+=$6;uv+=$7}END{print "HQHY pv数量：" pv "  uv数量：" uv}' ${file}
