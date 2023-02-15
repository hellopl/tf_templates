#!/bin/bash
yum -y update
yum -y install httpd


myip=`curl http://169.254.169.254/latest/meta-data/local-ipv4`

cat <<EOF > /var/www/html/index.html
<html>
<h2> Build by powerTerraformmmmmm <font color="red"> v1.3.7</font></h2><br>
Owner ${f_name} ${l_name} <br>

%{ for x in names ~}
Hello to ${x} from ${f_name}<br>
%{ endfor ~}
<p>
Server IP: $myip<br>
</html>
EOF

#sudo systemctl start httpd.service
#sudo systemctl enable httpd.service
sudo service httpd start
chkconfig httpd on