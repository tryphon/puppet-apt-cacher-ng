class apt_cacher_ng (
  $version = 'installed'
) {

  anchor { 'begin': } ->
  class { 'apt_cacher_ng::install': } ->
  class { 'apt_cacher_ng::config': } ~>
  class { 'apt_cacher_ng::service': } ->
  anchor { 'end': }

}
