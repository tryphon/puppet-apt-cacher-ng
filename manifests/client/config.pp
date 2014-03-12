class apt-cacher-ng::client::config {

  File {
    owner  => root,
    group  => root,
    mode   => '0644',
    ensure => present,
  }
  case $apt-cacher-ng::client::autodetect {
    false: {
      case $apt-cacher-ng::client::server {
        "": { fail("server not specified") }
        default: { }
      }
      case $apt-cacher-ng::client::servers {
        "": { }
        default: { fail("servers must only be specified with autodetect=true") }
      }
      file { "/etc/apt/apt.conf.d/71proxy":
        content => "Acquire::http { Proxy \"http://${apt-cacher-ng::client::server}\"; };",
      }
      file { "/etc/apt/apt.conf.d/30detectproxy":
        ensure => absent,
      }
    }
    true: {
      file { "/etc/apt/apt.conf.d/71proxy":
        ensure => absent,
      }
      file { "/etc/apt/apt.conf.d/30detectproxy":
        source => "puppet:///modules/apt-cacher-ng/30detectproxy",
      }
      case $apt-cacher-ng::client::verbose {
        true:    { $show_proxy_messages = 1 }
        false:   { $show_proxy_messages = 0 }
        default: { fail("verbose must be true or false, not ${apt-cacher-ng::client::verbose}.") }
      }
      case $apt-cacher-ng::client::server {
        "": {
          case $apt-cacher-ng::client::servers {
            "":      { fail("must specify either server or servers") }
            default: { $proxies = $apt-cacher-ng::client::servers }
          }
        }
        default: {
          case $apt-cacher-ng::servers {
            "":      { $proxies = [$apt-cacher-ng::client::server] }
            default: { fail("cannot specify both server and servers") }
          }
        }
      }
      if (!is_integer($apt-cacher-ng::client::timeout)) {
        fail("timeout must be an integer")
      }
      file { "/etc/apt/detect-http-proxy":
        content => template("apt-cacher-ng/detect-http-proxy.erb"),
        mode   => '0755',
      }
      file { "/etc/apt/proxy.conf":
        content => template("apt-cacher-ng/apt-proxy-conf.erb"),
      }
    }
    default: {
      fail("autodetect must be true or false, not ${apt-cacher-ng::client::autodetect}.")
    }
  }

}
