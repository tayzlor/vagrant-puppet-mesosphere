
Exec { path => ["/usr/bin", "/usr/sbin", "/bin"] }

service { 'iptables':
  ensure   => 'stopped',
  enable => 'false',
}

include docker
include zookeeper
#include marathon

class{'mesos::master': }

class{ 'mesos::slave':
  zookeeper  => 'zk://127.0.0.1:2181'
}
