include basenode
class { 'mesos':
  zookeeper => $zookeeper
}
class { 'mesos::master':
  options   => {
    quorum  => $quorum,
    log_dir => '/var/log/mesos'
  },
  zookeeper => $zookeeper,
}

# We split the string into back into an array here because Vagrant
# does not yet support structured facts for Puppet provisioning.
$servers = split($zookeeper_servers, ',')
class { 'zookeeper':
  id      => $zookeeper_id,
  servers => $servers
}
class { 'marathon':
  marathon_zk => $marathon_zk
}

# Ensure Slave service not running on master nodes.
service { 'mesos-slave':
  ensure => stopped,
  enable => false
}
