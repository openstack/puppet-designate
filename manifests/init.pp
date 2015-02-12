# == Class designate
#
# Configure designate service
#
# == Parameters
#
# [*service_ensure*]
#  (optional) Whether the designate-common package will be present..
#  Defaults to 'present'
#
# [*debug*]
#   (optional) should the daemons log debug messages.
#   Defaults to 'false'
#
# [*verbose*]
#   (optional) should the daemons log verbose messages.
#   Defaults to 'false'
#
# [*root_helper*]
#   (optional) Command for designate rootwrap helper.
#   Defaults to 'sudo designate-rootwrap /etc/designate/rootwrap.conf'.
#
# [*rabbit_host*]
#   (optional) Location of rabbitmq installation.
#   Defaults to '127.0.0.1'
#
# [*rabbit_port*]
#   (optional) Port for rabbitmq instance.
#   Defaults to '5672'
#
# [*rabbit_password*]
#   (optional) Password used to connect to rabbitmq.
#   Defaults to 'guest'
#
# [*rabbit_userid*]
#   (optional) User used to connect to rabbitmq.
#   Defaults to 'guest'
#
# [*rabbit_virtualhost*]
#   (optional) The RabbitMQ virtual host.
#   Defaults to '/'
#
class designate(
  $package_ensure       = present,
  $verbose              = false,
  $debug                = false,
  $root_helper          = 'sudo designate-rootwrap /etc/designate/rootwrap.conf',
  $rabbit_host          = '127.0.0.1',
  $rabbit_port          = '5672',
  $rabbit_userid        = 'guest',
  $rabbit_password      = '',
  $rabbit_virtualhost   = '/',
) {

  include designate::params
  package { 'designate-common':
    ensure => $package_ensure,
    name   => $::designate::params::common_package_name,
  }

  user { 'designate':
    name    => 'designate',
    gid     => 'designate',
    system  => true,
    require => Package['designate-common'],
  }

  group { 'designate':
    name    => 'designate',
    require => Package['designate-common'],
  }

  file { '/etc/designate/':
    ensure => directory,
    owner  => 'designate',
    group  => 'designate',
    mode   => '0750',
  }

  file { '/etc/designate/designate.conf':
    owner => 'designate',
    group => 'designate',
    mode  => '0640',
  }

  Package['designate-common'] -> Designate_config<||>

  designate_config {
    'DEFAULT/rabbit_host'            : value => $rabbit_host;
    'DEFAULT/rabbit_port'            : value => $rabbit_port;
    'DEFAULT/rabbit_hosts'           : value => "${rabbit_host}:${rabbit_port}";
    'DEFAULT/rabbit_userid'          : value => $rabbit_userid;
    'DEFAULT/rabbit_password'        : value => $rabbit_password, secret => true;
    'DEFAULT/rabbit_virtualhost'     : value => $rabbit_virtualhost;
  }

  # default setting
  designate_config {
    'DEFAULT/debug'                  : value => $debug;
    'DEFAULT/verbose'                : value => $verbose;
    'DEFAULT/root_helper'            : value => $root_helper;
    'DEFAULT/logdir'                 : value => $::designate::params::log_dir;
    'DEFAULT/state_path'             : value => $::designate::params::state_path;
  }

}
