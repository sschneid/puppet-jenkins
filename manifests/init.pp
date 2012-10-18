class jenkins {
  package {
    'jre':
        ensure => '1.7.0',
        noop   => true
  }
}
