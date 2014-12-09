include basenode
class { 'mesos::master':
  options   => {
    quorum  => $quorum
  },
  zookeeper => $zookeeper,
}
