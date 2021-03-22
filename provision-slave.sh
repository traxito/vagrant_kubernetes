#!/bin/bash
sudo yum install epel-release bash-completion tree wget curl -y
systemctl stop firewalld
systemctl disable firewalld
sed -i 's/^SELINUX=.*/SELINUX=disabled/g' /etc/selinux/config
sudo yum install ansible git -y
cd /root
git clone https://github.com/traxito/vagrant_ansible
#cp -r /redis_vagrant/provision/authorized_keys /root/.ssh
mkdir -p /root/.ssh
cp /root/vagrant_ansible/provision/id_rsa.pub /root/.ssh
cp /root/vagrant_ansible/provision/authorized_keys /root/.ssh
cp /root/vagrant_ansible/provision/sudoers /etc
cp /root/vagrant_ansible/provision/hosts /etc/
