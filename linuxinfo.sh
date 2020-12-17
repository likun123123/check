#!/bin/bash
#
#远程连接后
#echo -n "Please enter your create user os ip: " 
#read name
#ssh root@$name  
##################系统硬件详细信息###############################
##############################################################
read -p "请输入你的主机名" a
echo "//================================================\\"
echo "|         new system list                         |"
echo "---------------------------------------------------"
echo "|     hostname     |              $a                  |"

conf_path="bash"
curr_date=date
wait_time="1"
#判断当前用户是否有查询系统信息的权限
if [ $UID -gt 0 ] ;then
   echo "该用户没有管理员权限，无法采集系统信息！"
fi
user_who=`awk 'NR==1{print}'$conf_path/tmp.log`;
   echo ""$user_who;sleep $wait_time
if [ "$user_who"!= "root" ];then
   echo "Is no root!!!"
exit 0;
fi
#系统信息采集
path=`echo $PWD`;echo "当前目录: "$path;sleep $wait_time
char=`echo $LANG`;echo "当前字符集:" $char;sleep $wait_time
host=`hostname`;echo "主机名:" $host;sleep $wait_time
ver=`uname -a`;echo "内核版本:"$ver;sleep $wait_time
cpu=`cat /proc/cpuinfo|grep model|grep name |awk '{print $4,$5,$6,$7,$8}'`
   echo "CPU:" $cpu;sleep $wait_time
#系统状态
echo "================================================================"
echo "----当前主板信息----";sleep $wait_time;lspci
echo "----当前监听端口----";sleep $wait_time
netstat -tnlp |grep LISTEN |awk '{print $1"\t" $4"\t" $6"\t" $7"\t"}' 
echo "----当前磁盘状态----";sleep $wait_time;df -h
echo "----当前内存空间----";sleep $wait_time;free -m
#连接用户查询
echo "================================================================"
user=`uptime|awk '{print $5}'`;echo "当前连接用户的数量:"$user;
echo "---当前连接用户信息---";sleep $wait_time;w
echo "---当前系统进程---";sleep $wait_time;ps -A
echo "================================================================"
#Mem Maximum Capacity
echo "设备最大支持内存信息"
dmidecode -t 16 | grep Maximum 
#Memory Device
ehco "命令获取内存插槽插了几条内存，每条多大，还有多少空闲内存插槽相关信息"dmidecode|grep -P -A5 "Memory Device" | grep Size | grep -v Range



###############################负载信息########################################
#############################################################################
#
echo "kernel version"
uname -r 
#
echo "cpu amount"
 cat /proc/cpuinfo |grep "processor"|wc -l
#
echo "cpu parameter"
cat /proc/cpuinfo | grep name | cut -f2 -d: | uniq -c

#
echo "mount position"
dh -T
echo "--------------------------------------------------"
echo "--------------------------------------------------"
#
echo "load status"
uptime
#
echo "OS Kernel"
vmstat 2 5
#
echo ""
mpstat -P ALL 1 5 | sort -k2nr |head 
#
echo "seize course mark"
pidstat 1 2 | awk -F' ' '{print $3,$7}'
#
echo "io course mark"
iostat -xz 1 1 |awk -F' ' 'NR>5{print $4,$5,46,$7}'
#
echo "top analyse"
top -c -b -n 2 |head -n 20
