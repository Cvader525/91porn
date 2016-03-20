#!/bin/bash
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
            echo "example: 91.sh -u http://xxx.xxx.xxx/xxxx or -u http://xxx.xxx.xxx/xxxx -p ip:port "
            exit 1
        ;;
    esac
done

#proxy="--socks 112.124.51.136:1080"


checkvid(){
if [ ! -n "$vid" ]
then
	echo "video vid is null,plase use proxy or change proxy";
	exit;
fi
}

urldecode() {

    local url_encoded="${1//+/ }"
    printf '%b' "${url_encoded//%/\\x}"

}

checkFileType(){
    	if test $fileType = "mp4"; then
            name=$title"."$fileType
        else
            name=$title".mp4"
        fi
}

readDown_Json(){
while read line var
do
	if [ ! -n  "$line" ]
	then
		echo " readDown_Json is empty!";
		contiune;
	fi

	if [ "$line" != "" ]; then
	    urldecode $(cat ./91/down_Json) > ./91/down_Json
		videolink=$(cat ./91/down_Json | cut -d \& -f 1-2 | cut -d = -f 2-4)
		fileType=$(echo $videolink |cut -d ? -f 1 |awk -F . '{print $NF}')
        checkFileType
		wget -c -O ${name} $videolink
	fi

done < ./91/down_Json
}

download(){
while read line var
do
	if [ ! -n  "$line" ]
	then
		echo "is empty!";
		continue;
	fi

	if [ "$line" != "" ]; then

		if [ ! -f "./91/list_temp" ]; then
			touch ./91/list_temp
		fi

		if cat ./91/list_temp | grep $line ;then
			echo "continue is link";
			continue;
		fi

		curl $proxy  $line  $cookie -v -A "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/48.0.2564.116 Safari/537.36"  -o ./91/video_page

		echo $(cat ./91/video_page | grep "游客")
		echo $(cat ./91/video_page | grep "IP")
		vid=$(cat ./91/video_page | grep -o ^so.*file.*\' | cut -d \' -f 4)
		checkvid $vid
		seccode=$(cat ./91/video_page | grep -o ^so.*seccode.*\' | cut -d \' -f 4)
		max_vid=$(cat ./91/video_page | grep -o ^so.*max_vid.*\' | cut -d \' -f 4)
		title=$(cat ./91/video_page | grep -E "title" |sed -n "1,2p" | sed 's/<[^>]*>//g'|tr -d "\n" | sed 's/  *//g' )

		jsonurl="${domain_name}/getfile.php?VID="$vid"&mp4=0&seccode="$seccode"&max_vid="$max_vid;
		curl $proxy  $jsonurl  $cookie -v -A "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/48.0.2564.116 Safari/537.36" -o ./91/down_Json
		readDown_Json |cut -d \& -f 1
	fi

done < ./91/list_url

}

check_repetition(){
	sort -n ./91/list_url | uniq > ./91/temp
	rm -f ./91/list_url
	mv ./91/temp ./91/list_url

}

read_list(){
	curl  $proxy   $url $cookie -v -A "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/48.0.2564.116 Safari/537.36"  -o ./91/list_page
	cat ./91/list_page | grep -o "${domain_name}/view_video.php?viewkey=\w*" >> ./91/list_url
	check_repetition
	download
}




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
