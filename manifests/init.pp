class apt-cacher-ng {

  $real_apt_cacher_version = $ensure_apt_cacher ? {
    '' => "installed",
    default => $ensure_apt_cacher
  }

  package { apt-cacher-ng:
    ensure => $real_apt_cacher_version
  }

  service { apt-cacher-ng:
    ensure => running,
    require => Package[apt-cacher-ng]
  }

  file { "/etc/apt-cacher-ng/acng.conf":
    source => "puppet:///apt-cacher-ng/acng.conf",
    notify => Service[apt-cacher-ng],
    require => Package[apt-cacher-ng]
  }

  file { "/var/cache/apt-cacher-ng":
    owner => apt-cacher-ng,
    ensure => directory,
    require => Package[apt-cacher-ng]
  }

}
