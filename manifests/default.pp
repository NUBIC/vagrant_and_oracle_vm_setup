node default {
  include oracle::server
  include oracle::swap
  include oracle::xe

  user { "vagrant":
    groups => "dba",
    require => Service["oracle-xe"],
  }

}
