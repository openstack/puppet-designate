# Class designate

class designate(
  $package_ensure       = present,
  $verbose              = false,
  $debug                = false,
  $rabbit_host          = '127.0.0.1',
  $rabbit_port          = '5672',
  $rabbit_userid        = 'guest',
  $rabbit_password      = '',
  $rabbit_virtualhost   = '/',
) {

  include designate::params
  include ::dns
  package { 'designate-common':
    ensure => $package_ensure,
    name   => $::designate::params::common_package_name,
  }

  user { 'designate':
    name    => 'designate',
    gid     => 'designate',
    groups  => ['designate','named'],
    system  => true,
    require => [Package['openstack-designate'],Class['::dns']],
  }

  group { 'designate':
    name    => 'designate',
    require => Package['openstack-designate'],
  }

  file { '/etc/designate/':
    ensure  => directory,
    owner   => 'designate',
    group   => 'designate',
    mode    => '0750',
  }

  file { '/etc/designate/designate.conf':
    owner   => 'designate',
    group   => 'designate',
    mode    => '0640',
  }

  Package['openstack-designate'] -> Designate_config<||>

  designate_config {
    'DEFAULT/rabbit_host'            : value => $rabbit_host;
    'DEFAULT/rabbit_port'            : value => $rabbit_port;
    'DEFAULT/rabbit_hosts'           : value => "${rabbit_host}:${rabbit_port}";
    'DEFAULT/rabbit_userid'          : value => $rabbit_userid;
    'DEFAULT/rabbit_password'        : value => $rabbit_password;
    'DEFAULT/rabbit_virtualhost'     : value => $rabbit_virtualhost;
  }

  # default setting
  designate_config {
    'DEFAULT/debug'                  : value => $debug;
    'DEFAULT/verbose'                : value => $verbose;
    'DEFAULT/root_helper'            : value => '';
    'DEFAULT/logdir'                 : value => $::designate::params::log_dir;
    'DEFAULT/state_path'             : value => $::designate::params::state_path;
  }

}
