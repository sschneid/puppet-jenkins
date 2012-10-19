class jenkins::firewall {
  if defined(Class['firewall']) {
    firewall { '500 allow Jenkins inbound traffic':
        proto  => 'tcp',
        dport  => '8080',
        jump   => 'ACCEPT',
    }
  }
}
