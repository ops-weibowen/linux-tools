#!/bin/bash

### 批量命令执行脚本 v1.0 #####

list="/root/shell/host.list"

if [ $# -lt 1  ]
then
   echo "请添加远程指令 eg: ./admin-cmd.sh cmd1 [-ops] "
   exit 1
fi

if [[ "$1" =~  (rm|init|usedel) ]]
then
   echo -e  "\033[31m **** 正在执行敏感指令，请谨慎操作 **** \033[0m"
   sleep 2
fi


cat -n $list
echo "---------------------------------"
read -p "请输入要执行命令的主机编号或者分组名称,输入ALL可发送到所有主机： " num

### 获取ip列表 #######################
ip=""
if [ "$num" = "ALL" ]
then
   ip=`cat $list | grep "^[0-9]"`
elif [ ! "$num" = "ALL" ] && [[ $num =~ ^[a-Z] ]]
then
   res=`grep "\<$num\>" $list | wc -l`
   if [ $res -eq 0 ]
   then
      echo "分组不存在"
      exit 1
   else
   ip=`sed -n '/'$num'/,/^[[]/{p}' $list  | grep  "^[1-9]"`
   fi
else
 	for i in `echo $num`
	do
 		ip="$ip `cat -n $list | awk 'NR=='$i'&& $NF ~ /^[0-9]/{print $NF}'`"
	done
fi

#### 按照 ip 列表实际循环操作 ###################
for n in `echo $ip`
do
   echo  -e "______________ 正在连接 \033[1;31m $n \033[0m __________________"
   echo $*
   ssh  $n  "$*"
done


