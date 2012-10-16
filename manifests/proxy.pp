class jenkins::proxy (
  $port       = '80',
  $site_alias = undef,
  $ssl        = undef,
) {
  if ($site_alias) {
    $real_site_alias = $site_alias
  }
  else {
    $real_site_alias = $::fqdn
  }

  a2mod { [ 'proxy_balancer', 'proxy_ajp' ]: ensure => present, }

  if ($ssl) {
    $port = '443'

    apache::vhost::redirect {
      "jenkins_redirect_$real_site_alias":
        port => '80',
        dest => "https://$real_site_alias",
    }
  }

  apache::port {
    "jenkins_proxy_$real_site_alias":
      port => $port,
  }

  apache::vhost::proxy {
    "jenkins_proxy_$real_site_alias":
      serveraliases => "$real_site_alias",
      port          => $port,
      ssl           => $ssl,
      dest          => 'http://localhost:8080',
  }
}
