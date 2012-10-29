class jenkins::agent (
  $name      = undef,
  $server    = undef,

  $username  = undef,
  $password  = undef,

  $executors = undef,
  $launcher  = undef,
  $homedir   = undef,
  $ssh_user  = undef,
  $ssh_key   = undef,
  $labels    = undef,
) inherits jenkins {
  if ($server) {
    @@jenkins_agent { $::fqdn:
      name      => $name,
      server    => $server,

      username  => $username,
      password  => $password,

      executors => $executors,
      launcher  => $launcher,
      homedir   => $homedir,
      ssh_user  => $ssh_user,
      ssh_key   => $ssh_key,
      labels    => $labels,
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
