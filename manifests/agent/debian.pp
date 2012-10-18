class jenkins::agent::debian {
  package {
    [
      'default-jre-headless',
    ]:
      ensure => 'installed',
  }
}
