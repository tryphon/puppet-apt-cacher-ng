class apt_cacher_ng::client::config {

  File {
    owner  => root,
    group  => root,
    mode   => '0644',
    ensure => present,
  }

  if $apt_cacher_ng::client::autodetect {
    case $apt_cacher_ng::client::server {
      "": { fail("server not specified") }
      default: { }
    }
    case $apt_cacher_ng::client::servers {
      "": { }
      default: { fail("servers must only be specified with autodetect=true") }
    }
    file { "/etc/apt/apt.conf.d/71proxy":
      content => "Acquire::http { Proxy \"http://${apt_cacher_ng::client::server}\"; };",
    }
    file { "/etc/apt/apt.conf.d/30detectproxy":
      ensure => absent,
    }
  }
  else {
    file { "/etc/apt/apt.conf.d/71proxy":
      ensure => absent,
    }
    file { "/etc/apt/apt.conf.d/30detectproxy":
      source => "puppet:///modules/apt_cacher_ng/30detectproxy",
    }

    $show_proxy_messages = bool2num($apt_cacher_ng::client::verbose)

    case $apt_cacher_ng::client::server {
      "": {
        case $apt_cacher_ng::client::servers {
          "":      { fail("must specify either server or servers") }
          default: { $proxies = $apt_cacher_ng::client::servers }
        }
      }
      default: {
        case $apt_cacher_ng::servers {
          "":      { $proxies = [$apt_cacher_ng::client::server] }
          default: { fail("cannot specify both server and servers") }
        }
      }
    }

    file { "/etc/apt/detect-http-proxy":
      content => template("apt_cacher_ng/detect-http-proxy.erb"),
      mode   => '0755',
    }
    file { "/etc/apt/proxy.conf":
      content => template("apt_cacher_ng/apt-proxy-conf.erb"),
    }
  }

}
