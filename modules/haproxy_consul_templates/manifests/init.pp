class haproxy_consul_templates() {
  file { '/tmp/haproxy.conf.ctmpl':
    source => "puppet:///modules/haproxy_consul_templates/haproxy.conf.ctmpl",
  }
  consul_template::template { 'haproxy':
    source      => '/tmp/haproxy.conf.ctmpl',
    destination => "/etc/haproxy/haproxy.cfg",
    command     => "service haproxy restart"
  }
}
