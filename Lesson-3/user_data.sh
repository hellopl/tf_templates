#!/bin/bash
yum -y update
yum -y install httpd
myip=`curl http://169.254.169.254/latest/meta-data/local-ipv4`
echo "<h2>WebServer with IP: $myip</h2><br><body bgcolor=pink><center><h2><p><font color=black>Build by Terraform using external script!!!" > /var/www/html/index.html
sudo systemctl start httpd.service
sudo systemctl enable httpd.service