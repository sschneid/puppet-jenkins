class jenkins::agent::debian {
  package {
    [
      'autoconf',
      'automake',
      'bison',
      'build-essential',
      'curl',
      'git-core',
      'libc6-dev',
      'libncurses5-dev',
      'libreadline5',
      'libreadline6-dev',
      'libsqlite3-dev',
      'libssl-dev',
      'libtool',
      'libxml2-dev',
      'libxslt-dev',
      'libyaml-dev',
      'openssl',
      'sqlite3',
      'subversion',
      'zlib1g',
      'zlib1g-dev',
    ]:
      ensure => 'installed',
  }
}
