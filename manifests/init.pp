class apt_cacher_ng (
  $version    = 'installed',
  $admin_user = false,
  $admin_pw   = false
) {

  if $admin_user != false and $admin_pw != false {
    validate_string($admin_user)
    validate_string($admin_pw)
  }
  else {
    if ($admin_user != false and $admin_pw == false) or
       ($admin_user == false and $admin_pw != false) {
      fail('Please set either none or both of $admin_user and $admin_pw.')
    }
  }

  anchor { 'apt_cacher_ng::begin': } ->
  class { 'apt_cacher_ng::install': } ->
  class { 'apt_cacher_ng::config': } ~>
  class { 'apt_cacher_ng::service': } ->
  anchor { 'apt_cacher_ng::end': }

}
