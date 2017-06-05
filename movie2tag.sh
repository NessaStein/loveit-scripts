#!/bin/sh
# Author: NeSsA

# usage:
# list3包含需要匹配的电影名称，douban每次接受一个电影名称，输出匹配的电影类型到output.txt
# for i in `cat list3.txt`;do echo `bash movie2tag.sh $i` | tee -a ~/output.txt;done 

# 命令行接受参数电影名称
MovieName=$1

# 豆瓣搜索判断搜索结果只有一条
count=`curl https://movie.douban.com/subject_search?search_text=${MovieName} 2>/dev/null | grep "class=\"nbg.*${MovieName}\""|cut -d '"' -f 4 |wc -l`

if [[ $count -eq "1" ]]
then 
    curl https://movie.douban.com/subject_search?search_text=${MovieName} 2>/dev/null | grep "class=\"nbg.*${MovieName}\""|cut -d '"' -f 4|xargs curl 2>/dev/null | grep "v:genre"|awk '{split($0,a,"[><]");print a[7], a[11], a[15], a[19], a[23], a[27], a[31], a[35], a[39], a[43], a[47], a[51], a[55]}'
else
    # 这里来看看百度词条，同样是先判断是否有记录，记录为一条。
    count1=`curl -L http://baike.baidu.com/item/${MovieName} 2>/dev/null|egrep -A2 "类&nbsp;&nbsp;&nbsp;&nbsp;型"|tail -1|sed 's/，/ /g' | wc -l`
    if [[ $count1 -eq "1" ]]
    then
        curl -L http://baike.baidu.com/item/${MovieName} 2>/dev/null|egrep -A2 "类&nbsp;&nbsp;&nbsp;&nbsp;型"|tail -1|sed 's/，/ /g'
    else
        echo null
    fi
fi
