#!/bin/sh
case $1 in
   start) cd /opt/django-celery/ && celery -A celery_pro beat -l info >  out.file  2>&1  & ;; #  /opt/django-celery/ 是django项目的根目录                  
   stop) su root /opt/beat_stop.sh start ;; # 启动另一个脚本,该脚本在/opt目录下
   *) echo "require start|stop" ;;
esac
