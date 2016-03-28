# 91porn

bash 版本视频下载，目前仅支持单个视频下载

#软件环境(Ubuntu/Debian system)</br>
  1.sudo apt-get install wget </br>
  2.sudo apt-get install curl</br>

#使用方法</br>

sh run.sh -u "url" -p "ip:port" -s "ip:port"</br>

后面2个参数是可选的，URL 是必填</br>
-u 是指url</br>
-p 是指http代理ip和端口，为了解决浏览次数限制，举例192.168.1.1:8080，具体的IP地址自己在网上寻找</br>
-s 是指ss 代理方式</br>

#更新列表</br>

2016.03.28</br>
   1.删除调试代码</br>
   2.分拆脚本方法</br>
   3.修改url编码方法，能力有限修改为获取在线编码后的数据</br>

2016.02.28 </br>
  1.修改运行参数模式</br>
  2.添加代理模式：支持http 和 socks5</br>
  3.添加任意91 URL支持（你们懂的）</br>
  4.修改urldecode编码方法，解决mac兼容问题</br>
  
2015-11-28 </br>
  1.修复新版无法下载问题</br>
#bug</br>
目前有时候会被拦截，要求开启cookie的使用</br>
