include basenode
include haproxy
haproxy::listen { 'puppet00':
  collect_exported => false,
  ipaddress        => $::ipaddress,
  ports            => '80',
}
class { 'consul':
  join_cluster => $join_cluster,
  config_hash => {
    'data_dir'         => '/opt/consul',
    'log_level'        => 'INFO',
    'client_addr'      => '0.0.0.0',
    'advertise_addr'   => $ip,
    'node_name'        => $node_name,
    'datacenter'       => $datacenter
  }
}

# Join the cluster manually. We do this to circumvent the issues described
# over here -
# https://github.com/solarkennedy/puppet-consul/pull/42
# https://github.com/solarkennedy/puppet-consul/issues/31
exec {'slave join consul cluster':
  cwd         => $consul::config_dir,
  path        => [$consul::bin_dir,'/bin','/usr/bin'],
  command     => "consul join ${join_cluster}",
  subscribe   => Service['consul'],
  require     => Class['consul'],
}
include haproxy_consul_templates
class { 'consul_template':
  require => Service['consul'],
}
