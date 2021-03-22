#!/bin/bash
#install utils and Docker
sudo yum install epel-release bash-completion tree wget curl sftp python-argcomplete yum-utils -y
 sudo yum-config-manager \
    --add-repo \
    https://download.docker.com/linux/centos/docker-ce.repo
systemctl stop firewalld
systemctl disable firewalld
sudo yum install docker-ce docker-ce-cli containerd.io
sudo systemctl start docker
systemctl stop firewalld
systemctl disable firewalld
#install containerd (prepared for when the installation is automated detected for Kubeadm)
#cat <<EOF | sudo tee /etc/modules-load.d/containerd.conf
#overlay
#br_netfilter
#EOF
#sudo modprobe overlay
#sudo modprobe br_netfilter
#sudo mkdir -p /etc/containerd
#containerd config default | sudo tee /etc/containerd/config.toml
#sudo systemctl restart containerd
#set up kubernetes installation
cat <<EOF | sudo tee /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-\$basearch
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
exclude=kubelet kubeadm kubectl
EOF
# Set SELinux in permissive mode (effectively disabling it)
sudo setenforce 0
sed -i 's/^SELINUX=.*/SELINUX=disabled/g' /etc/selinux/config
#Make sure that the br_netfilter module is loaded
sudo modprobe br_netfilter
sudo yum install -y git kubelet kubeadm kubectl --disableexcludes=kubernetes
sudo systemctl enable --now kubelet
cd /root
git clone https://github.com/traxito/vagrant_kubernetes
#cp -r /redis_vagrant/provision/authorized_keys /root/.ssh
mkdir -p /root/.ssh
cp /root/vagrant_kubernetes/id_rsa.pub /root/.ssh
cp /root/vagrant_kubernetes/authorized_keys /root/.ssh
cp /root/vagrant_kubernetes/sudoers /etc
cp /root/vagrant_kubernetes/hosts /etc/
