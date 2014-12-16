include basenode
include zookeeper
include marathon
include mesos::master
include mesos::slave

# Provision Consul if its enabled in common.yml.
$consul_enable = hiera('consul_enable')
if $consul_enable {
  include consul
  include consul_template
}

include haproxy
haproxy::listen { 'puppet00':
  collect_exported => false,
  ipaddress        => $::ipaddress,
  ports            => '80',
}
include haproxy_consul_templates
