# -*- mode: ruby -*-
# vi: set ft=ruby :

ORACLE_MESSAGE = <<ERROR
  ERROR: Can't find the Oracle RPM file!
  Please put oracle-xe-11.2.0-1.0.x86_64.rpm.zip into the ./modules/oracle/files/ directory
  You can download it at:
  http://www.oracle.com/technetwork/products/express-edition/downloads/index.html
ERROR

HIERA_MESSAGE = <<ERROR
  ERROR: Can't find the configuration file!
  Please create a hiera.yaml file from the hiera.yaml.example template in the ./puppetconfig/ directory
ERROR

raise ORACLE_MESSAGE unless File.exist?("modules/oracle/files/oracle-xe-11.2.0-1.0.x86_64.rpm.zip")
raise HIERA_MESSAGE unless File.exist?("puppetconfig/hiera.yaml")

Vagrant.configure("2") do |config|

  config.vm.box = "precise64"
  config.vm.box_url = "http://files.vagrantup.com/precise64.box"

  ######### Edit this to your liking:
  config.vm.hostname = "oracletest"

  # Forward Oracle port
  config.vm.network :forwarded_port, guest: 1521, host: 1521

  config.vm.provider :virtualbox do |vb|
    vb.customize ["modifyvm", :id,
                  "--name", config.vm.hostname,
                  "--memory", "4096",
                  "--natdnshostresolver1", "on"]
  end

  config.vm.provision :shell, :inline => "echo \"America/Chicago\" | sudo tee /etc/timezone && dpkg-reconfigure --frontend noninteractive tzdata"

  config.vbguest.auto_update = false

  config.vm.provision :puppet do |puppet|
    puppet.module_path = "modules"
    puppet.options = "--verbose --trace"
    # puppet.facter = {
    #   "nodename" => config.vm.hostname
    # }
    # puppet.options = "--hiera_config /vagrant/puppetconfig/hiera.yaml"
  end
end
