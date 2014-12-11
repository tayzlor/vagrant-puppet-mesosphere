# $zookeeper, $quorum, $ip and $marathon_zk are passed in
# from the Vagrantfile depending on the cluster set up in cluster.yml

include basenode
class { 'mesos':
  zookeeper => $zookeeper
}
class { 'mesos::master':
  options    => {
    quorum   => $quorum,
    log_dir  => '/var/log/mesos',
    hostname => $ip,
    ip       => $ip,
  },
  zookeeper => $zookeeper,
}
class { 'zookeeper':
  id => $zookeeper_id,
}
class { 'marathon':
  marathon_zk => $marathon_zk
}

# Ensure Slave service not running on master nodes.
service { 'mesos-slave':
  ensure => stopped,
  enable => false,
  require => Package['mesos']
}
