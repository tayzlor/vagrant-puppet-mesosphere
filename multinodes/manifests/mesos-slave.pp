include basenode
class { 'mesos':
  zookeeper => $zookeeper
}
class { 'mesos::slave':
  zookeeper => $zookeeper,
}

# Ensure we are not running zk, mesos-master or marathon on slave nodes.
service { 'mesos-master':
  ensure => stopped,
  enable => false
}
service { 'zookeeper':
  ensure => stopped,
  enable => false
}
service { 'marathon':
  ensure => stopped,
  enable => false,
}
