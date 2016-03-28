#!/bin/bash
. ./download.sh
echo '======your must setting -u option========= '


cookie="-b language=cn_CN;watch_times=0"

get_domain_name(){

http_check=$(echo $url | cut -d '/' -f "1");
if  test $http_check = "http:"; then
    domain_name=$(echo $url | cut -d '/' -f "1-3")
    echo $domain_name
elif test $http_check = "https:"; then
    domain_name=$(echo $url | cut -d '/' -f "1-3")
    echo $domain_name
else
    domain_name=$(echo $url | cut -d '/' -f "1")
    echo $domain_name
fi
}


while getopts "u:p:" arg #选项后面的冒号表示该选项需要参数
do
    case $arg in
        u)
            url=$OPTARG
            get_domain_name
            ;;
        p)
            #echo "b's arg:$OPTARG"
            proxy="-x "$OPTARG
            ;;
        s)
            proxy="--socks "$OPTARG
            ;;
        ?)
            echo "example: run.sh -u http://xxx.xxx.xxx/xxxx or -u http://xxx.xxx.xxx/xxxx -p ip:port "
            exit 1
        ;;
    esac
done





if [ -d "./91" ]; then
	rm -f -R ./91
	mkdir ./91
else
	mkdir ./91
fi

if echo $url | grep "v.php" ;then
	read_list $url
else
	echo $url > ./91/list_url
	download
fi
