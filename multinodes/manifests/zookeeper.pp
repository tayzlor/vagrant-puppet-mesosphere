include basenode

# We split the string into back into an array here because Vagrant
# does not yet support structured facts for Puppet provisioning.
$zookeeper_servers = split($servers, ', ')
validate_array($zookeeper_servers)

class { 'zookeeper':
  id      => $id,
  servers => $zookeeper_servers,
}
