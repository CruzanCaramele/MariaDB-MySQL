mysql -e "mysql -hmaster.prod.internal -ubackup -ppassword"
mysql -e "mysqldump -hmaster.prod.internal -ubackup -ppassword --all-databases > /centos/home/backup.sql"
chmod 777 /centos/home/backup.sh
aws s3 sync /root s3://dbBucketBacking/