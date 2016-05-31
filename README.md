# nginx-nfs-failover

```
Crontab
* * * * * timeout 10 /root/report/failover-nginx-root.sh >/dev/null 2>&1
* * * * * ( sleep 15 ; timeout 10 /root/report/failover-nginx-root.sh >/dev/null 2>&1 )
```
