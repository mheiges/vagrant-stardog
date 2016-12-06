# Install Stardog (http://stardog.com)
class profiles::stardog {

  include ::profiles::ebrc_ca_bundle
  include ::ebrc_yum_repo
  include ::ebrc_java
  include ::stardog
  
  Class['ebrc_yum_repo'] ->
  Class['ebrc_java'] ->
  Class['profiles::ebrc_ca_bundle'] ->
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
  }

  # Hack to fix Vagrant landrush DNS NATing clobbered by firewalld
  # reload. Without this the resource server setup will fail due to
  # failure to resolve the iCAT hostname.
  Firewalld_rich_rule {
    subscribe => Exec['save_landrush_iptables'],
    notify    => Exec['restore_landrush_iptables'],
  }
  exec { 'save_landrush_iptables':
    command     => '/sbin/iptables-save -t nat > /root/landrush.iptables',
    refreshonly => true,
  }
  exec { 'restore_landrush_iptables':
    command     => '/sbin/iptables-restore < /root/landrush.iptables',
    refreshonly => true,
  }

}
