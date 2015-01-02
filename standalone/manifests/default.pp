include basenode
include zookeeper
include marathon
include mesos::master
include mesos::slave

# Provision Consul if its enabled in common.yml.
$consul_enable = hiera('consul_enable')
if $consul_enable {
  include consul
  class { 'consul_template':
    require => Service['consul'],
  }

  #include dnsmasq
  #dnsmasq::conf { 'consul':
  #  ensure  => present,
  #  content => 'server=/consul/127.0.0.1#8600',
  #}
}

include haproxy
haproxy::listen { 'puppet00':
  collect_exported => false,
  ipaddress        => $::ipaddress,
  ports            => '80',
}
include haproxy_consul_templates
