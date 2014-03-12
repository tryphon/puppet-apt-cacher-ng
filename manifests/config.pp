class apt-cacher-ng::config {

  file { '/etc/apt-cacher-ng/acng.conf':
    source => [
      "puppet:///modules/site-apt-cacher-ng/${::fqdn}/acng.conf",
      'puppet:///modules/site-apt-cacher-ng/acng.conf',
      'puppet:///modules/apt-cacher-ng/acng.conf'
    ],
  }

  file { '/var/cache/apt-cacher-ng':
    ensure  => directory,
    owner   => 'apt-cacher-ng',
  }

}
