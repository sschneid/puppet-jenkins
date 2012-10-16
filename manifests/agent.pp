class jenkins::agent {
  case $::operatingsystem {
    'Debian': { include jenkins::agent::debian }

    default: {
      fail( "Unsupported operating system: ${::operatingsystem}" )
    }
  }
}

