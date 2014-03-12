class apt-cacher-ng (
  $version = 'installed'
) {

  anchor { 'begin': } ->
  class { 'apt-cacher-ng::install': } ->
  class { 'apt-cacher-ng::config': } ~>
  class { 'apt-cacher-ng::service': } ->
  anchor { 'end': }

}
