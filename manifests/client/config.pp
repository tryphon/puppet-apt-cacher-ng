class apt_cacher_ng::client::config {

  if ! $apt_cacher_ng::client::autodetect {
    include apt_cacher_ng::client::one_proxy
    class { 'apt_cacher_ng::client::autodetect':
      ensure => absent,
    }
  }
  else {
    class { 'apt_cacher_ng::client::one_proxy':
      ensure => absent,
    }
    include apt_cacher_ng::client::autodetect
  }

}
