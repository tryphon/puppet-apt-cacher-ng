class apt-cacher-ng::install {

  package { 'apt-cacher-ng':
    ensure => $apt-cacher-ng::version,
  }

}
