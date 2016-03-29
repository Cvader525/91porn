#!/usr/bin/env bash


checkvid(){
if [ ! -n "$vid" ]
then
	echo "video vid is null,plase use proxy or change proxy";
	exit;
fi
}

urldecode() {

    echo $(curl -d "content=$(cat ./91/down_Json)&charsetSelect=utf-8&de=UrlDecode%E8%A7%A3%E7%A0%81" http://tool.chinaz.com/tools/urlencode.aspx | grep -E 'file'  |sed 's/<[^>]*>//g'| sed  's/\&amp;/\&/g' ) > ./91/down_Json

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
		urldecode
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
		echo "download line is empty!";
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
