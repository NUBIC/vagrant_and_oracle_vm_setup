class oracle::server {

  exec { "apt-update":
      command => "/usr/bin/apt-get -y update",
      timeout => 3600;
  }

  package {
    ["alien", "bc", "libaio1", "unixodbc", "unzip", "rlwrap"]:
      ensure => installed;
  }

  exec {
    "procps":
      refreshonly => true,
      command => "/etc/init.d/procps start";
  }

  file {
    "/sbin/chkconfig":
      mode => 0755,
      source => "puppet:///modules/oracle/chkconfig";
    "/etc/sysctl.d/60-oracle.conf":
      notify => Exec['procps'],
      source => "puppet:///modules/oracle/60-oracle.conf";
    "/etc/rc2.d/S01shm_load":
      mode => 0755,
      source => "puppet:///modules/oracle/S01shm_load";
  }

  user {
    "syslog":
      ensure => present,
      groups => ["syslog", "adm"];
  }

  group {
    "puppet":
      ensure => present;
  }

  exec {
    "set up shm":
      command => "/etc/rc2.d/S01shm_load start",
      require => File["/etc/rc2.d/S01shm_load"],
      user => root,
      unless => "/bin/mount | grep /dev/shm 2>/dev/null";
  }

  Exec["apt-update"] -> Package <| |>
}
