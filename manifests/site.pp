
Exec { path => ["/usr/bin", "/usr/sbin", "/bin"] }

exec { 'install-mesos-repo':
  command   => 'rpm -Uvh http://repos.mesosphere.io/el/6/noarch/RPMS/mesosphere-el-repo-6-2.noarch.rpm',
  creates   => '/etc/yum.repos.d/mesosphere.repo',
  logoutput => on_failure
}

service { 'iptables':
  ensure  => 'stopped',
  enable  => 'false',
}

include docker
include zookeeper
#include marathon

class{ 'mesos::master':
  require => Exec['install-mesos-repo']
}

class{ 'mesos::slave':
  zookeeper  => 'zk://127.0.0.1:2181',
  require    => Exec['install-mesos-repo']
}
