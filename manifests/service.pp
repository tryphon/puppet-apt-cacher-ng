class apt_cacher_ng::service {

  service { 'apt-cacher-ng':
    ensure  => running,
  }

}
