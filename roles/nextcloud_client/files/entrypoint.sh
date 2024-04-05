#! /bin/bash
# copy config if not exists (this can be mounted)
# (should always exists as you should use this with the accompanying ansible script)
cp -nr /nclient/config_org/* /nclient/config

echo "------- removing all old crontabs -------"
crontab -r

echo "------- create env vars for cronjob  -------"
printenv | grep 'UNAME=\|PASS=\|SERVER=\|SYNC_FOLDER' > /nclient/env # env vars the cron job uses
cat /nclient/env

echo "------- add our cron script using crontab -------"
crontab /nclient/config/nclient_crontab

echo "------- listen to cron -------"
sudo cron -f
