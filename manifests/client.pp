class apt-cacher-ng::client($server_url) {
  file { "/etc/apt/apt.conf.d/71proxy":
    owner   => root,
    group   => root,
    mode    => '0644',
    content => 'Acquire::http { Proxy "${server_url}"; };',
  }
}
