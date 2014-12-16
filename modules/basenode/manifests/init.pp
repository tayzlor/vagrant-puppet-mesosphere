class basenode() {
  Exec { path => ["/usr/bin", "/usr/sbin", "/bin", "/sbin"] }

  case $::osfamily {
    'Debian': {
      package { ['python-setuptools', 'python-protobuf']:
        ensure => present
      }
    }

    'Redhat': {
      package { [ 'glibc-headers', 'gcc-c++', 'python-setuptools', 'protobuf', 'redhat-lsb']:
        ensure => present
      }

      package { 'cloudera-cdh':
        ensure => 'installed',
        source => 'http://archive.cloudera.com/cdh4/one-click-install/redhat/6/x86_64/cloudera-cdh-4-0.x86_64.rpm',
        provider => 'rpm'
      }

      file { 
        '/etc/pki/rpm-gpg/RPM-GPG-KEY-mesosphere':
          ensure => present,
          source => 'puppet:///modules/basenode/RPM-GPG-KEY-mesosphere';
        '/etc/init.d/marathon':
          ensure => present,
          source => 'puppet:///modules/basenode/marathon',
          mode   => '0554';
        '/etc/init.d/zookeeper':
          ensure => present,
          source => 'puppet:///modules/basenode/zookeeper',
          mode   => '0554';
        '/etc/init.d/mesos-master':
          ensure => present,
          source => 'puppet:///modules/basenode/mesos-master',
          mode   => '0554';
        '/etc/init.d/mesos-slave':
          ensure => present,
          source => 'puppet:///modules/basenode/mesos-slave',
          mode   => '0554';
        '/opt/marathon':
          ensure => "directory";
        '/var/log/mesos':
          ensure => present,
          owner  => vagrant;
      }

      exec { 'rpm --import http://archive.cloudera.com/cdh4/redhat/6/x86_64/cdh/RPM-GPG-KEY-cloudera':
      }

      yumrepo { "mesosphere":
        baseurl  => "http://repos.mesosphere.io/el/${::operatingsystemmajrelease}/\$basearch/",
        descr    => "Mesosphere Packages for EL - ${::operatingsystemmajrelease}",
        enabled  => 1,
        gpgcheck => 1,
        gpgkey   => 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-mesosphere',
        require  => File['/etc/pki/rpm-gpg/RPM-GPG-KEY-mesosphere'],
      }
    }
  }

  include docker
}
