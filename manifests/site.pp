augeas {
  'selinux':
  context => '/files/etc/sysconfig/selinux',
  changes => [ 'set SELINUX disabled' ];
}

Exec { path => ["/usr/bin", "/usr/sbin", "/bin"] }

include java
include docker

#class { 'zookeeper':
#  require => Exec['install-zookeeper-repo']
#}
#include zookeeper
include mesos::master
include marathon

class{ 'mesos::slave':
  zookeeper  => 'zk://127.0.0.1:2181'
}
