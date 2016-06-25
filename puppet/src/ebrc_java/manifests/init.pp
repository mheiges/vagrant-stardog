# == Class: ebrc_java
#
# Manages Java installation for given $package name
#
# === Parameters
#
#  $package - name of java package to install, e.g. jdk-1.7.0_80
#  $java_home - full path to JAVA_HOME, e.g. /usr/java/jdk1.7.0_80
#  $default_ver - /usr/java/default symlink points to this directory in
#  /usr/java. This symlink is originally created by the Oracle RPM. "By
#  /default, usr/java/default points to /usr/java/latest. However, if
#  /administrators change /usr/java/default to point to another version
#  /of Java, subsequent package upgrades will be provided by the
#  /administrators and cannot be overwritten."
#   - http://www.oracle.com/technetwork/java/javase/install-linux-rpm-137089.html
#
# === Authors
# Mark Heiges <mheiges@uga.edu>
#
class ebrc_java (
  $packages,
  $java_home,
  $default_ver = '/usr/java/latest',
) {

  package { $packages :
    ensure  => installed,
  }

  file { '/etc/profile.d/java.sh':
    ensure  => present,
    content => template('ebrc_java/java.sh'),
    require => Package[$packages],
  }

  if $default_ver != undef {
    file { '/usr/java/default':
      ensure => 'link',
      target => $default_ver,
    }
  }

  # required dirs to make Oracle's jdk-1.7.0 compatible with CentOS's ant
  #file { ['/usr/share/java-1.7.0', '/usr/lib/java-1.7.0']:
  #  ensure  => directory,
  #  require => Class['::java'],
  #}

}
