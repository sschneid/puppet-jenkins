class jenkins::agent (
  $server = undef,
) inherits jenkins {
  if ($server) {
    @@jenkins_agent { $::fqdn:
      server => $server,
    }
  }

  case $::operatingsystem {
    'Debian': { include jenkins::agent::debian }

    default: {
      fail( "Unsupported operating system: ${::operatingsystem}" )
    }
  }
}
