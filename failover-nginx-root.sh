#!/bin/sh
##NGINX FAILOVER ROOT DIRECTORY##

#check nfs mount status
df -P -T /storage-pool/nfs-1 | tail -n +2 | awk '{print $2}' | grep nfs | wc -l > /root/status/nfs-1
df -P -T /storage-pool/nfs-2 | tail -n +2 | awk '{print $2}' | grep nfs | wc -l > /root/status/nfs-2

#give time to fetch nfs content
sleep 5

CHECK_FILE_1=`cat /root/status/nfs-1`
CHECK_FILE_2=`cat /root/status/nfs-2`

CHECK_NGINX_1=`grep 'nfs-1' /etc/nginx/sites-enabled/tonjoo.com | wc -l`
CHECK_NGINX_2=`grep 'nfs-2' /etc/nginx/sites-enabled/tonjoo.com | wc -l`

#slack's channel
TO=#tonjoo

if [ $CHECK_FILE_1 -ne 1 ] && [ $CHECK_NGINX_1 -eq 1 ] && [ $CHECK_FILE_2 -eq 1 ]
	then
	sed -i 's/nfs-1/nfs-2/g' /etc/nginx/sites-enabled/tonjoo.com
        nginx -t && echo 'move to nfs-2'
        nginx -s reload
	bash /root/report/slack.sh $TO REPORT 'Nginx root changed to nfs-2'

elif [ $CHECK_FILE_2 -ne 1 ] && [ $CHECK_NGINX_2 -eq 1 ] && [ $CHECK_FILE_1 -eq 1 ]
	then
	sed -i 's/nfs-2/nfs-1/g' /etc/nginx/sites-enabled/tonjoo.com
        nginx -t && echo 'move to nfs-1'
        nginx -s reload
	bash /root/report/slack.sh $TO REPORT 'Nginx root changed to nfs-1'

elif [ $CHECK_FILE_1 -ne 1 ] && [ $CHECK_FILE_2 -ne 1 ]
        then
        echo 'All nfs-server down'
        bash /root/report/slack.sh $TO REPORT 'All nfs-server down'

else
	echo 'OK'

fi

