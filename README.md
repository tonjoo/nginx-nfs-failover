# nginx-nfs-failover

``Crontab``
* * * * * timeout 20 /root/report/fail.sh >/dev/null 2>&1
* * * * * ( sleep 30 ; timeout 20 /root/report/fail.sh >/dev/null 2>&1 )

