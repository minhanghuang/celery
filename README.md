@[toc]


# #0 blog

https://blog.csdn.net/Coxhuang/article/details/86921407
https://blog.csdn.net/Coxhuang/article/details/86481343



# #1 环境

```
centos 6.9 
django==2.0.7
celery==3.1.23
django-celery==3.2.2
```

# #2 celery使用(定时任务)

[https://blog.csdn.net/Coxhuang/article/details/86481343
](https://blog.csdn.net/Coxhuang/article/details/86481343)


# #3 后台启动worker / beat

## #3.1 后台运行Worker

```
celery multi start w1 -A  celery_pro -l info  # 开始
celery multi stop w1 -A  celery_pro -l info # 结束
```

> 设置成脚本文件


```
vim /opt/celery_worker.sh
```

```
#!/bin/sh 
case $1 in                                        
   start) cd /opt/django-celery/ && celery multi start w1 -A  celery_pro -l info;;  # django项目根目录 : /opt/django-celery/
   stop) cd /opt/django-celery/ && celery multi stop w1 -A  celery_pro -l info;; # django项目根目录 : /opt/django-celery/
   *) echo "require start|stop" ;;     
esac
```

> 使用


```
sh celery_worker.sh start # 开启
sh celery_worker.sh stop # 关闭
```


## #3.3 后台运行 beat

> 没有找到官方提供的beat后台运行命令,所以,自己写

- 后台启动beat


> 新增脚本 vim /opt/celery_beat.sh 


```
vim /opt/celery_beat.sh
```

```
#!/bin/sh
case $1 in  
   start) cd /opt/django-celery/ && celery -A celery_pro beat -l info >  out.file  2>&1  & ;; # 启动beat ; django项目根目录 : /opt/django-celery/
esac 
```


- 关闭beat 

> 新增脚本 vim /opt/beat_stop.sh 

```
vim /opt/beat_stop.sh
```

```
#!/bin/sh               
PROCESS=`ps -ef|grep celery|grep -v grep|grep -v PPID|awk '{ print $2}'`
for i in $PROCESS         
do
  echo "Kill the $1 process [ $i ]"  
  kill -9 $i        
done 
```

> 编辑脚本 vim /opt/celery_beat.sh  

```
vim /opt/celery_beat.sh
```

```
#!/bin/sh
case $1 in  
   start) cd /opt/django-celery/ && celery -A celery_pro beat -l info >  out.file  2>&1  & ;; # 启动beat  ; django项目根目录 : /opt/django-celery/
   stop) su root /opt/beat_stop.sh start ;; # 关闭beat(根据beat_stop.sh脚本的路径适当变化)
   *) echo "require start|stop" ;;
esac 
```


![在这里插入图片描述](https://img-blog.csdnimg.cn/2019021018245453.png)


### #6.3 使用小结
- 后台启动worker, sh celery_worker.sh start
- 后台关闭worker, sh celery_worker.sh stop
- 后台启动beat, sh celery_beat.sh start
- 后台关闭beat, sh celery_beat.sh stop


### #6.4 测试

![在这里插入图片描述](https://img-blog.csdnimg.cn/20190210182540831.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L0NveGh1YW5n,size_16,color_FFFFFF,t_70)

![在这里插入图片描述](https://img-blog.csdnimg.cn/2019021018260718.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L0NveGh1YW5n,size_16,color_FFFFFF,t_70)
