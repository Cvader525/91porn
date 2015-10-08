#!/bin/bash
echo "plase input your link!"
read url
#url=http://91porn.com/view_video.php?viewkey=9e6a0e30542d21511018;
cookie="-b language=cn_CN;watch_times=0"
browser="-A Mozilla/5.0 (Windows NT 6.3; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/41.0.2272.101 Safari/537.36"

checkvid(){
if [ ! -n "$vid" ] 
then
	echo vid is null;
	continue;
fi
}

readDown_Json(){
while read line var
do
	if [ ! -n  "$line" ]
	then 
		echo "is empty!";
		continue;
	fi

	if [ "$line" != "" ]; then
		videolink=$(cat ./91/down_Json | cut -d \& -f 1 | cut -d = -f 2)
		wget $videolink
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
		curl $line $cookie -A "Mozilla/5.0 (Windows NT 6.3; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/43.0.2357.130 Safari/537.36"  -o ./91/video_page
		vid=$(cat ./91/video_page | grep -o ^so.*file.*\' | cut -d \' -f 4)
		echo $line >> list_temp;	
		checkvid $vid
		seccode=$(cat ./91/video_page | grep -o ^so.*seccode.*\' | cut -d \' -f 4)
		max_vid=$(cat ./91/video_page | grep -o ^so.*max_vid.*\' | cut -d \' -f 4)
		jsonurl="http://91porn.com/getfile.php?VID="$vid"&seccode="$seccode"&max_vid="$max_vid"&mp4=1"
		curl $jsonurl  $cookie -A "Mozilla/5.0 (Windows NT 6.3; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/43.0.2357.130 Safari/537.36" -o ./91/down_Json
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
	curl $url $cookie -A "Mozilla/5.0 (Windows NT 6.3; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/43.0.2357.130 Safari/537.36"  -o ./91/list_page
	cat ./91/list_page | grep -o "http://www.91porn.com/view_video.php?viewkey=\w*" >> ./91/list_url
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

