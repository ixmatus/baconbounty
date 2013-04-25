# -*- mode: ruby -*-
# vi: set ft=ruby :

require 'vagrant-ansible'

Vagrant::Config.run do |config|
  
  config.vm.box = "quantal_haskell-amd64"
  config.vm.box_url = "https://secure.whooshtraffic.com/static/downloads/quantal_haskell-amd64.box"
  
  config.vm.host_name = "vhaskell"
  
  # Upgrading to cabal-install needs more than 512MB of RAM
  config.vm.customize ["modifyvm", :id, "--memory", "512"]

  # Typically you want to adjust to the CPU's on your machine
  config.vm.customize ["modifyvm", :id, "--cpus", "2"]

  config.vm.forward_port 8080, 8080
  config.vm.forward_port 1234, 1234

  # Shared folders
  hosthome = "#{ENV['HOME']}/"
  pwd = File.expand_path(File.dirname(__FILE__))
  
  config.vm.share_folder("v-vhaskell", "/vhaskell", ".", :nfs => true)
  config.vm.share_folder("v-hosthome", "/home/vagrant/.hosthome", hosthome)
  
  # Host-only network required to use NFS shared folders
  config.vm.network :hostonly, "2.3.4.5"

  # Provisioning -------------------------------------------------------------
  config.vm.provision :shell, :inline => "su vagrant -c /vhaskell/provisioning/shell/init-system.sh"
  config.vm.provision :shell, :inline => "su vagrant -c /vhaskell/provisioning/shell/install-ansible.sh"
  
  config.vm.provision :ansible do |ansible|
    ansible.playbook = "provisioning/vhaskell.yml"
    ansible.hosts = "vhaskell"
  end
end
