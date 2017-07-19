#!/bin/sh
# Author: NeSsA

# usage:
# list3包含需要匹配的电影名称
# for i in `cat list3.txt`;do echo `bash tag.sh $i` | tee -a ~/output.txt;done 

#输出格式：节目名称	节目类型	节目类别	主演	导演	出品时间	地区
#echo "节目名称#类型#类别#主演#导演#出品时间#地区"


# 命令行接受参数电影名称
MovieName=$1

curl -L http://baike.baidu.com/item/${MovieName} >/tmp/aaa.html 2>/dev/null

#判断是否是一条，如果多条不匹配输出null
count1=`cat /tmp/aaa.html|egrep -A2 "类&nbsp;&nbsp;&nbsp;&nbsp;型"|tail -1|sed 's/，/ /g' | wc -l`

# 判断是否有集数字段，如果有那么就输出电视剧
jishu=`cat /tmp/aaa.html|egrep -A2 "集&nbsp;&nbsp;&nbsp;&nbsp;数"|tail -1|sed 's/，/ /g' | wc -l`
dianying=`cat /tmp/aaa.html|egrep  "电影评价"|wc -l`
qishu=`cat /tmp/aaa.html|egrep -A2 "期&nbsp;&nbsp;&nbsp;&nbsp;数"|tail -1|sed 's/，/ /g' | wc -l`

if [[ $count1 -eq "1" ]]
then
	echo -n "${MovieName}#" 

	echo -n "$(cat /tmp/aaa.html|awk '/<div class="basic-info cmn-clearfix">/,/<\/dl><\/div>/{print $0}'|sed -e 's/<[^<>]*>//g' -e '/^\s*$/d' -e 's/&nbsp;//g'|grep -E -A1 "类型"|tail -1)#"

	#... 电视剧，综艺节目，电影判断输出
	if [[ $jishu -eq "1" ]]
	then
		echo -n "电视剧#"
	elif [[ $dianying -eq "1" ]]
	then
		echo -n "电影#"
	elif [[ $qishu -eq "1" ]]
	then
		echo -n "综艺节目"
	else
		echo -n "其他#"
	fi
	#...

	echo -n "$(cat /tmp/aaa.html|awk '/<div class="basic-info cmn-clearfix">/,/<\/dl><\/div>/{print $0}'|sed -e 's/<[^<>]*>//g' -e '/^\s*$/d' -e 's/&nbsp;//g'|grep -E -A1 "主演"|tail -1)#"
	echo -n "$(cat /tmp/aaa.html|awk '/<div class="basic-info cmn-clearfix">/,/<\/dl><\/div>/{print $0}'|sed -e 's/<[^<>]*>//g' -e '/^\s*$/d' -e 's/&nbsp;//g'|grep -E -A1 "导演"|tail -1)#"
	echo -n "$(cat /tmp/aaa.html|awk '/<div class="basic-info cmn-clearfix">/,/<\/dl><\/div>/{print $0}'|sed -e 's/<[^<>]*>//g' -e '/^\s*$/d' -e 's/&nbsp;//g'|grep -E -A1 "上映时间|出品时间"|tail -1)#"
	echo -n "$(cat /tmp/aaa.html|awk '/<div class="basic-info cmn-clearfix">/,/<\/dl><\/div>/{print $0}'|sed -e 's/<[^<>]*>//g' -e '/^\s*$/d' -e 's/&nbsp;//g'|grep -E -A1 "地区"|tail -1)#"
else
	echo null
fi
