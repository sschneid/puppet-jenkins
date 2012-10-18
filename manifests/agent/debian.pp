class jenkins::agent::debian {
  package {
    [
      'build-essential',
      'default-jre-headless',
    ]:
      ensure => 'installed',
  }
}
