class apt_cacher_ng::config {

  file { '/etc/apt-cacher-ng/acng.conf':
    source => [
      "puppet:///modules/site_apt_cacher_ng/${::fqdn}/acng.conf",
      'puppet:///modules/site_apt_cacher_ng/acng.conf',
      'puppet:///modules/apt_cacher_ng/acng.conf'
    ],
  }

  file { '/var/cache/apt-cacher-ng':
    ensure  => directory,
    owner   => 'apt-cacher-ng',
  }

}
