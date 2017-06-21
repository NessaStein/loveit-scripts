#!/bin/bash
# Author NeSsA

file=$1

for i in `gawk -F, 'NR>1 && !a[$5]++ && $5!~/^[0-9]+/ && $5!="NULL"{print $5}' ${file}`;do gawk -F, '$5=="'$i'"{pv+=$6;uv+=$7}END{print "'$i' pv数量：" pv "  uv数量：" uv}' ${file};done
