include basenode
class { 'mesos::slave':
  zookeeper => $zookeeper,
}
