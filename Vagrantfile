require 'yaml'

VAGRANTFILE_API_VERSION = "2"

ORACLE_MESSAGE = <<ERROR
ERROR: Can't find the Oracle RPM file!
  Please put oracle-xe-11.2.0-1.0.x86_64.rpm.zip into the ./oracle/ directory
  You can download it at:
  http://www.oracle.com/technetwork/products/express-edition/downloads
ERROR

CONFIG_MISSING_MESSAGE = <<ERROR
  ERROR: Can't find the configuration file!
Please create a config.yaml file from the config.yaml.example template
in the ./provisioning/ directory
ERROR

unless File.exist?("oracle/oracle-xe-11.2.0-1.0.x86_64.rpm.zip")
  raise ORACLE_MESSAGE
end

unless File.exist?("provisioning/config.yml")
  raise CONFIG_MISSING_MESSAGE
end


## -- Add dump files to the yaml file for the database -------------------------
config = YAML.load_file "provisioning/config.yml"
dmps = Dir["oracle/dump/*.dmp"]
databases = dmps.collect { |f| "#{f.gsub("oracle/dump/","").gsub(".dmp","")}" }
config["databases"] = databases

## -- Adding extra sql files

extra_sql = Dir["oracle/custom_sql/**/*.sql"]
processed = extra_sql.collect { |f|
  "#{f.gsub("oracle/custom_sql/","").gsub(".sql","")}"
}

sql_final = Array.new
processed.each do |sql|
  split_file = sql.split("/")
  database = split_file.size > 1 ? split_file.first : "system"
  sql_final << Hash["db" => database, "file" => split_file.last]
end

config["extra_sql"] = sql_final
File.open("provisioning/config.yml", 'w') { |f| YAML.dump(config, f) }

# ---------------------------------------------------------------------------

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "centos-64-x86_64"
  config.vm.box_url =
    "https://dl.dropboxusercontent.com/u/3318148/vagrant/CentOS-6.4-x86_64.box"

  config.vm.provider :virtualbox do |vb|
    vb.customize ["modifyvm", :id,
                  "--memory", "1024",
                  "--name",   config["vm_name"],
                  ]
  end

  config.vm.provision :shell, :inline =>
    "echo \"America/Chicago\" | sudo tee /etc/timezone && dpkg-reconfigure" \
    " --frontend noninteractive tzdata"

  config.vm.provision "ansible" do |ansible|
    ansible.playbook = "provisioning/oracle-xe.yml"
    ansible.extra_vars = "provisioning/config.yml"
    ansible.verbose = 'v'
    ansible.host_key_checking = 'false'
  end

  config.vm.synced_folder ".", "/vagrant",
    mount_options: ['dmode=777', 'fmode=777']

  config.vm.network "forwarded_port",
    guest: 1521,
    host: 1521,
    auto_correct: true

end
