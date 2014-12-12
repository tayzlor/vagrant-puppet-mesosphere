class basenode() {
  Exec { path => ["/usr/bin", "/usr/sbin", "/bin", "/sbin"] }

  package { ['python-setuptools', 'python-protobuf']:
    ensure => present
  }

  case $::osfamily {
    'Redhat': {

      file { '/etc/pki/rpm-gpg/RPM-GPG-KEY-mesosphere':
        ensure => present,
        source => 'puppet:///modules/basenode/RPM-GPG-KEY-mesosphere'
      }

      yumrepo { "mesosphere":
        baseurl  => "http://repos.mesosphere.io/el/${::operatingsystemmajrelease}/",
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
