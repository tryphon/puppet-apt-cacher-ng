class apt_cacher_ng::client::config {

  File {
    ensure => present,
    owner  => root,
    group  => 0,
    mode   => '0644',
  }

  if ! $apt_cacher_ng::client::autodetect {
    $server = $apt_cacher_ng::client::servers[0]
    file { '/etc/apt/apt.conf.d/71proxy':
      content => "Acquire::http { Proxy \"http://${server}\"; };",
    }
    file { '/etc/apt/apt.conf.d/30detectproxy':
      ensure => absent,
    }
  }
  else {
    file { '/etc/apt/apt.conf.d/71proxy':
      ensure => absent,
    }
    file { '/etc/apt/apt.conf.d/30detectproxy':
      source => 'puppet:///modules/apt_cacher_ng/30detectproxy',
    }

    $show_proxy_messages = bool2num($apt_cacher_ng::client::verbose)

    file { '/etc/apt/detect-http-proxy':
      content => template('apt_cacher_ng/detect-http-proxy.erb'),
      mode    => '0755',
    }
    file { '/etc/apt/proxy.conf':
      content => template('apt_cacher_ng/apt-proxy-conf.erb'),
    }
  }

}
