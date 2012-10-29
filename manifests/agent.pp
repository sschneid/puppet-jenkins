class jenkins::agent (
  $labels = undef,
  $server = undef,
) inherits jenkins {
  if ($server) {
    @@jenkins_agent { $::fqdn:
      labels => $labels,
      server => $server,
    }
  }

  include java

  case $::operatingsystem {
    'Debian': { include jenkins::agent::debian }

    default: {
      fail( "Unsupported operating system: ${::operatingsystem}" )
    }
  }
}
