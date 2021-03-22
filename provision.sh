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
#Using the systemd cgroup driver
#sed -i 's/^SystemdCgroup = false.*/SystemdCgroup = true/g' /etc/containerd/config.toml
#sudo systemctl restart containerd
# Setup required sysctl params, these persist across reboots.
cat <<EOF | sudo tee /etc/sysctl.d/99-kubernetes-cri.conf
net.bridge.bridge-nf-call-iptables  = 1
net.ipv4.ip_forward                 = 1
net.bridge.bridge-nf-call-ip6tables = 1
EOF

# Apply sysctl params without reboot
sudo sysctl --system
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
mkdir -p /root/.ssh
cp /root/vagrant_kubernetes/id* /root/.ssh
chmod 600 /root/.ssh/id_rsa
cp /root/vagrant_kubernetes/hosts /etc/
cp /root/vagrant_kubernetes/sudoers /etc/
#only for Hyper-v
#ip=$(ip -4 addr show eth0 | grep -oP '(?<=inet\s)\d+(\.\d+){3}')
#echo $ip "ansible_hostname=master-ansible ansible_connection=local package=ftp" >> /etc/ansible/hosts
