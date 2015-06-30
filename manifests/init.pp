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
    tag    => ['openstack', 'designate-package'],
  }

  if $package_ensure != 'absent' {
    Package['designate-common'] -> User['designate']
    Package['designate-common'] -> Group['designate']
  }

  user { 'designate':
    ensure => 'present',
    name   => 'designate',
    gid    => 'designate',
    system => true,
    before => Anchor['designate::install::end'],
  }

  group { 'designate':
    ensure => 'present',
    name   => 'designate',
    before => Anchor['designate::install::end'],
  }

  file { '/etc/designate/':
    ensure => directory,
    owner  => 'designate',
    group  => 'designate',
    mode   => '0750',
  }

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

  # Setup anchors for install, config and service phases of the module.  These
  # anchors allow external modules to hook the begin and end of any of these
  # phases.  Package or service management can also be replaced by ensuring the
  # package is absent or turning off service management and having the
  # replacement depend on the appropriate anchors.  When applicable, end tags
  # should be notified so that subscribers can determine if installation,
  # config or service state changed and act on that if needed.
  anchor { 'designate::install::begin': } ->
  Package<| tag == 'designate-package'|> ~>
  anchor { 'designate::install::end': }
  ->
  anchor { 'designate::config::begin': } ->
  Designate_config<||> ~>
  anchor { 'designate::config::end': }
  ->
  anchor { 'designate::service::begin': } ~>
  Service<| tag == 'designate-service' |> ~>
  anchor { 'designate::service::end': }

  # Package installation or config changes will always restart services.
  Anchor['designate::install::end'] ~> Anchor['designate::service::begin']
  Anchor['designate::config::end']  ~> Anchor['designate::service::begin']
}
