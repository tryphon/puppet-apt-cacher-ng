class apt-cacher-ng::client (
  $server = $apt-cacher-ng::client::params::server,
  $servers = $apt-cacher-ng::client::params::servers,
  $autodetect = $apt-cacher-ng::client::params::autodetect,
  $verbose = $apt-cacher-ng::client::params::verbose,
  $timeout = $apt-cacher-ng::client::params::timeout
) inherits apt-cacher-ng::client::params {

  anchor { 'begin': } ->
  class { 'apt-cacher-ng::client::config': } ->
  anchor { 'end': }

}
