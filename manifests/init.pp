class apt-cacher-ng($version = 'installed') {
  package { 'apt-cacher-ng':
    ensure => $version,
  }

  service { 'apt-cacher-ng':
    ensure  => running,
    require => Package['apt-cacher-ng'],
  }

  file { '/etc/apt-cacher-ng/acng.conf':
    source => ["puppet:///modules/site-apt-cacher-ng/${::fqdn}/acng.conf",
               'puppet:///modules/site-apt-cacher-ng/acng.conf',
               'puppet:///modules/apt-cacher-ng/acng.conf'],
    notify  => Service['apt-cacher-ng'],
    require => Package['apt-cacher-ng'],
  }

  file { '/var/cache/apt-cacher-ng':
    ensure  => directory,
    owner   => 'apt-cacher-ng',
    require => Package['apt-cacher-ng'],
  }
}
