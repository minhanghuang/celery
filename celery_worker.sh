#!/bin/sh 
case $1 in                                        
   start) cd /opt/django-celery/ && celery multi start w1 -A  celery_pro -l info;;  # django项目根目录 : /opt/django-celery/
   stop) cd /opt/django-celery/ && celery multi stop w1 -A  celery_pro -l info;; # django项目根目录 : /opt/django-celery/
   *) echo "require start|stop" ;;     
esac
