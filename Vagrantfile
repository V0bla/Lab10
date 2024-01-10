# -*- mode: ruby -*- 
# vi: set ft=ruby : vsa
  Vagrant.configure(2) do |config| 
    config.vm.box = "centos/8" 
    #config.vm.box_version = "20210210.0" 
    config.vm.provider "virtualbox" do |v| 
    v.memory = 256 
    v.cpus = 1 
  end 
  config.vm.define "lab10" do |lab10| 
    lab10.vm.network "private_network", type: "dhcp" 
    lab10.vm.hostname = "lab10"
    lab10.vm.provision "file", source: "script.sh", destination: "/tmp/script.sh"
    #lab10.vm.provision "shell" , path: "script.sh"
  end 
end 
