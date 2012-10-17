class agent::debian {
  package {
    [
      'autoconf',
      'automake',
      'bison',
      'build-essential',
      'curl',
      'git-core',
      'libc6-dev',
      'libreadline5',
      'libreadline6-dev',
      'libsqlite3-dev',
      'libssl-dev',
      'libtool',
      'libxml2-dev'
      'libxslt-dev',
      'libyaml-dev',
      'ncurses-dev',
      'openssl',
      'sqlite3',
      'subversion',
      'zlib1g',
      'zlib1g-dev',
    ]:
      ensure => 'installed',
  }
}
