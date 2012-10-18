class jenkins::server (
  $version = 'installed',
  $site_alias = undef,
) inherits jenkins {
  if ($site_alias) {
    $real_site_alias = $site_alias
  }
  else {
    $real_site_alias = $::fqdn
  }

  include jenkins::repo
  class {
    'jenkins::package':
      version => $version,
  }
  include jenkins::service
  include jenkins::firewall
  class {
    'jenkins::proxy':
      site_alias => $real_site_alias,
  }

  Class['jenkins::repo'] ->
  Class['jenkins::package'] ->
  Class['jenkins::service'] ->
  Class['jenkins::proxy']

}
