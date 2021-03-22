
Vagrant.configure("2") do |config|
  config.vm.box = "centos/7"

  
 # config.vm.network "private_network"
 # config.vm.provider "hyperv" do |hyperv|
 #   cpus = "1"
 #   maxmemory = "1024"
 #   hyperv.enable_virtualization_extensions = true
 #   hyperv.linked_clone = true
 # end

config.vm.provider "virtualbox" do |vb|
  vb.gui = false
  vb.cpus = 1
  vb.memory = "1024"
end

# master-ansible
config.vm.define "kube-master" do |app|
	config.vm.boot_timeout = 400
  #config.vm.synced_folder ".", "/vagrant"
    app.vm.hostname = "kube-master"
  # on VirtualBox, you can uncomment this line  
    app.vm.network "private_network", ip: "192.168.33.10"
    app.vm.provision "shell", path: "provision.sh"
	end

  # slave1
    config.vm.define "slave1" do |app|
	config.vm.boot_timeout = 400
  #config.vm.synced_folder ".", "/vagrant"
    app.vm.hostname = "slave1"
  # on VirtualBox, you can uncomment this line   
  app.vm.network "private_network", ip: "192.168.33.11"  
	app.vm.provision "shell", path: "provision-slave.sh"
	end
	# slave2
    config.vm.define "slave2" do |app|
	config.vm.boot_timeout = 400
  #config.vm.synced_folder ".", "/vagrant"
    app.vm.hostname = "slave2"
  # on VirtualBox, you can uncomment this line   
  app.vm.network "private_network", ip: "192.168.33.12"
	app.vm.provision "shell", path: "provision-slave.sh"
  end
end
