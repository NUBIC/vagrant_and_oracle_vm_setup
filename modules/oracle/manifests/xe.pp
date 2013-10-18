class oracle::xe {
  file {
    "/home/vagrant/oracle-xe-11.2.0-1.0.x86_64.rpm.zip":
      source => "puppet:///modules/oracle/oracle-xe-11.2.0-1.0.x86_64.rpm.zip";
    "/etc/profile.d/oracle-env.sh":
      source => "puppet:///modules/oracle/oracle-env.sh";
    "/tmp/xe.rsp":
      source => "puppet:///modules/oracle/xe.rsp";
    "/bin/awk":
      ensure => link,
      target => "/usr/bin/awk";
    "/var/lock/subsys":
      ensure => directory;
    "/var/lock/subsys/listener":
      ensure => present;
  }

  exec {
    "unzip xe":
      command => "/usr/bin/unzip -o oracle-xe-11.2.0-1.0.x86_64.rpm.zip",
      require => [Package["unzip"], File["/home/vagrant/oracle-xe-11.2.0-1.0.x86_64.rpm.zip"]],
      cwd => "/home/vagrant",
      user => root,
      creates => "/home/vagrant/oracle-xe-11.2.0-1.0.x86_64.rpm",
      unless => "/usr/bin/test -f /etc/default/oracle-xe";
    "alien xe":
      command => "/usr/bin/alien --to-deb --scripts Disk1/oracle-xe-11.2.0-1.0.x86_64.rpm",
      cwd => "/home/vagrant",
      require => [Package["alien"], Exec["unzip xe"]],
      creates => "/home/vagrant/oracle-xe_11.2.0-2_amd64.deb",
      user => root,
      timeout => 3600,
      unless => "/usr/bin/test -f /etc/default/oracle-xe";
    "configure xe":
      command => "/etc/init.d/oracle-xe configure responseFile=/tmp/xe.rsp >> /tmp/xe-install.log",
      require => [Package["oracle-xe"],
                  File["/etc/profile.d/oracle-env.sh"],
                  File["/tmp/xe.rsp"],
                  File["/var/lock/subsys/listener"],
                  Exec["set up shm"],
                  Exec["enable swapfile"]],
      creates => "/etc/default/oracle-xe";
  }

  package {
    "oracle-xe":
      provider => "dpkg",
      ensure => latest,
      require => [Exec["alien xe"]],
      source => "/home/vagrant/oracle-xe_11.2.0-2_amd64.deb",
  }

  service {
  	"oracle-xe":
  	  ensure => "running",
  	  require => [Package["oracle-xe"], Exec["configure xe"]],
  }
}
