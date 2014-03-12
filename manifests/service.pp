class apt-cacher-ng::service {

  service { 'apt-cacher-ng':
    ensure  => running,
  }

}
