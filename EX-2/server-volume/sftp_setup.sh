mkdir -p /data
chmod 701 /data
groupadd sftp_users
useradd -g sftp_users -d /upload -s /sbin/nologin sftp_usr
echo "sftp_usr:sftp" | chpasswd
mkdir -p /data/sftp_usr/upload
chown -R root:sftp_users /data/sftp_usr
chown -R sftp_usr:sftp_users /data/sftp_usr/upload
echo "Match Group sftp_users" >> /etc/ssh/sshd_config
echo "ChrootDirectory /data/%u" >> /etc/ssh/sshd_config
echo "ForceCommand internal-sftp" >> /etc/ssh/sshd_config
service ssh restart
hostname -I