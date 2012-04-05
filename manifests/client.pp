class apt-cacher-ng::client($server = "", $servers = "", $autodetect = true, $verbose = true) {
  File {
    owner  => root,
    group  => root,
    mode   => '0644',
    ensure => present,
  }
  case $autodetect {
    false: {
      case $server {
        "": { fail("server not specified") }
        default: { }
      }
      case $servers {
        "": { }
        default: { fail("servers must only be specified with autodetect=true") }
      }
      file { "/etc/apt/apt.conf.d/71proxy":
        content => 'Acquire::http { Proxy "http://${server}"; };',
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
      case $verbose {
        true:    { $show_proxy_messages = 1 }
        false:   { $show_proxy_messages = 0 }
        default: { fail("verbose must be true or false, not ${verbose}.") }
      }
      case $server {
        "":      { 
          case $servers {
            "":      { fail("must specify either server or servers") }
            default: { $proxies = $servers }
          }
        }
        default: {
          case $servers {
            "":      { $proxies = [$server] }
            default: { fail("cannot specify both server and servers") }
          }
        }
      }
      file { "/etc/apt/detect-http-proxy": 
        source => "puppet:///modules/apt-cacher-ng/detect-http-proxy",
        mode   => '0755',
      }
      file { "/etc/apt/proxy.conf":
        content => template("apt-cacher-ng/apt-proxy-conf.erb"),
      }
    }
    default: {
      fail("autodetect must be true or false, not ${autodetect}.")
    }
  }
}
