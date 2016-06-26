class profiles::stardog {

  include ebrc_yum_repo
  include ebrc_java
  include stardog
  
  Class['ebrc_yum_repo'] ->
  Class['ebrc_java'] ->
  Package['unzip'] ->
  Class['stardog']

  package { 'unzip':
    ensure => installed,
  }

  firewalld_rich_rule { 'stardog server':
    ensure    => present,
    zone      => 'public',
    port      => {
      'port'     => $stardog::port,
      'protocol' => 'tcp',
    },
    action    => 'accept',
    subscribe => Exec['save_landrush_iptables'],
    notify    => Exec['restore_landrush_iptables'],
  }

  # Hack to fix Vagrant landrush DNS NATing clobbered by firewalld
  # reload. Without this the resource server setup will fail due to
  # failure to resolve the iCAT hostname.
  exec { 'save_landrush_iptables':
    command     => '/sbin/iptables-save -t nat > /root/landrush.iptables',
    refreshonly => true,
  }
  exec { 'restore_landrush_iptables':
    command     => '/sbin/iptables-restore < /root/landrush.iptables',
    refreshonly => true,
  }

}
