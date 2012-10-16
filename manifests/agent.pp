class jenkins::agent {
  case $::operatingsystem {
    'Debian': { include jenkins::agent::debina }

    default: {
      fail( "Unsupported operating system: ${::operatingsystem}" )
    }
  }
}

