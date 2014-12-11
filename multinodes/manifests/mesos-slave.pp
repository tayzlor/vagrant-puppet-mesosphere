# $zookeeper, $ip are passed in from the Vagrantfile depending on the cluster
# set up in cluster.yml

include basenode
class { 'mesos':
  zookeeper => $zookeeper
}
class { 'mesos::slave':
  zookeeper => $zookeeper,
  options => {
    containerizers                => 'docker,mesos',
    executor_registration_timeout => '5mins',
    hostname                      => $ip,
    ip                            => $ip,
    log_dir                       => '/var/log/mesos'
  }
}

# Ensure we are not running zk, mesos-master or marathon on slave nodes.
service { 'mesos-master':
  ensure => stopped,
  enable => false,
  require => Package['mesos']
}
service { 'zookeeper':
  ensure  => stopped,
  enable  => false,
  require => Package['mesos']
}
