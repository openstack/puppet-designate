# == Class designate
#
# Configure designate service
#
# == Parameters
#
# [*package_ensure*]
#  (optional) The state of the package
#  Defaults to 'present'
#
# [*common_package_name*]
#  (optional) Name of the package containing shared resources
#  Defaults to common_package_name from designate::params
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
# [*rabbit_hosts*]
#   (Optional) Array of host:port (used with HA queues).
#   If defined, will remove rabbit_host & rabbit_port parameters from config
#   Defaults to undef.
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
  $common_package_name  = undef,
  $verbose              = false,
  $debug                = false,
  $root_helper          = 'sudo designate-rootwrap /etc/designate/rootwrap.conf',
  $rabbit_host          = '127.0.0.1',
  $rabbit_port          = '5672',
  $rabbit_hosts         = false,
  $rabbit_userid        = 'guest',
  $rabbit_password      = '',
  $rabbit_virtualhost   = '/',
) {

  include ::designate::params
  package { 'designate-common':
    ensure => $package_ensure,
    name   => pick($common_package_name, $::designate::params::common_package_name),
    tag    => 'openstack',
  }

  user { 'designate':
    ensure  => 'present',
    name    => 'designate',
    gid     => 'designate',
    system  => true,
    require => Package['designate-common'],
  }

  group { 'designate':
    ensure  => 'present',
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
    'DEFAULT/rabbit_userid'          : value => $rabbit_userid;
    'DEFAULT/rabbit_password'        : value => $rabbit_password, secret => true;
    'DEFAULT/rabbit_virtualhost'     : value => $rabbit_virtualhost;
  }

  if $rabbit_hosts {
    designate_config { 'DEFAULT/rabbit_hosts':     value => join($rabbit_hosts, ',') }
    designate_config { 'DEFAULT/rabbit_ha_queues': value => true }
    designate_config { 'DEFAULT/rabbit_host':      ensure => absent }
    designate_config { 'DEFAULT/rabbit_port':      ensure => absent }
  } else {
    designate_config { 'DEFAULT/rabbit_host':      value => $rabbit_host }
    designate_config { 'DEFAULT/rabbit_port':      value => $rabbit_port }
    designate_config { 'DEFAULT/rabbit_hosts':     value => "${rabbit_host}:${rabbit_port}" }
    designate_config { 'DEFAULT/rabbit_ha_queues': value => false }
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
