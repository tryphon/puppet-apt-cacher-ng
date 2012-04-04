stage { 'post': }

Stage ['main'] -> Stage ['post']

class apt_get_update {
  $sentinel = "/var/lib/apt/first-puppet-run"

  exec { "initial apt-get update":
    command => "/usr/bin/apt-get update && touch ${sentinel}",
    onlyif  => "/usr/bin/env test \\! -f ${sentinel} || /usr/bin/env test \\! -z \"$(find /etc/apt -type f -cnewer ${sentinel})\"",
    timeout => 3600,
  }
}

class test_server {
  group { 'puppet':
    ensure => "present",
  }

  class { 'apt_get_update':
    stage => post,
  }

  class { 'apt-cacher-ng':
  }

  file { "/etc/apt/apt.conf.d/71proxy": 
    owner   => root,
    group   => root,
    mode    => '0644',
    content => 'Acquire::http { Proxy "http://192.168.31.42:3142"; };',
  }
}

include test_server
