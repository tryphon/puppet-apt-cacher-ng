class apt_cacher_ng::client (
  $server = $apt_cacher_ng::client::params::server,
  $servers = $apt_cacher_ng::client::params::servers,
  $autodetect = $apt_cacher_ng::client::params::autodetect,
  $verbose = $apt_cacher_ng::client::params::verbose,
  $timeout = $apt_cacher_ng::client::params::timeout
) inherits apt_cacher_ng::client::params {

  validate_array($servers)
  validate_bool($autodetect)
  validate_bool($verbose)
  if !is_integer($timeout) {
    fail('Parameter $timeout is expected to be an integer value')
  }

  anchor { 'begin': } ->
  class { 'apt_cacher_ng::client::config': } ->
  anchor { 'end': }
}
