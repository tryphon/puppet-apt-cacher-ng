class apt-cacher-ng {
  package { 'apt-cacher-ng':
    ensure => present,
  }

  service { 'apt-cacher-ng':
    ensure  => running,
    require => Package['apt-cacher-ng'],
  }

  file { "/etc/apt-cacher-ng/acng.conf":
    source  => "puppet:///apt-cacher-ng/acng.conf",
    notify  => Service['apt-cacher-ng'],
    require => Package['apt-cacher-ng'],
  }

  file { "/var/cache/apt-cacher-ng":
    ensure  => directory,
    owner   => apt-cacher-ng,
    require => Package['apt-cacher-ng'],
  }
}
