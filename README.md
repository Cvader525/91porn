# 91porn

bash 版本视频下载，目前仅支持单个视频下载

#软件环境(Ubuntu/Debian system)
  1.sudo apt-get install wget 
  2.sudo apt-get install curl

#使用方法

sh 91.sh -u "url" -p "ip:port" -s "ip:port"

后面2个参数是可选的，URL 是必填

#更新列表

2016.02.28 
  1.修改运行参数模式
  2.添加代理模式：支持http 和 socks5
  3.添加任意91 URL支持（你们懂的）
  4.修改urldecode编码方法，解决mac兼容问题
  
2015-11-28 
  1.修复新版无法下载问题
#bug
目前有时候会被拦截，要求开启cookie的使用
