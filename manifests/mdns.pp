# == Class designate::mdns
#
# Configure designate Mini DNS service
#
# === Parameters:
#
# [*package_ensure*]
#   (Optional) The state of the package.
#   Defaults to 'present'.
#
# [*mdns_package_name*]
#   (Optional) Name of the package containing mdns resources.
#   Defaults to mdns_package_name from designate::params.
#
# [*enabled*]
#   (Optional) Whether to enable services.
#   Defaults to true.
#
# [*manage_service*]
#   (Optional) Whether the designate mdns service will be managed.
#   Defaults to true.
#
# [*workers*]
#   (Optional) Number of mdns worker processes to spawn.
#   Defaults to $facts['os_workers'].
#
# [*threads*]
#   (Optional) Number of mdns greenthreads to spawn.
#   Defaults to $facts['os_service_default'].
#
# [*tcp_backlog*]
#   (Optional) mDNS TCP Backlog.
#   Defaults to $facts['os_service_default'].
#
# [*tcp_recv_timeout*]
#   (Optional) mDNS TCP Receive Timeout.
#   Defaults to $facts['os_service_default'].
#
# [*query_enforce_tsig*]
#   (Optional) Enforce all incoming queries (including AXFR) are TSIG signed.
#   Defaults to $facts['os_service_default'].
#
# [*storage_driver*]
#   (Optional) The storage driver to use.
#   Defaults to $facts['os_service_default'].
#
# [*max_message_size*]
#   (Optional) Maximum message size to emit.
#   Defaults to $facts['os_service_default'].
#
# [*listen*]
#   (Optional) mDNS host:port pairs to listen on.
#   Defaults to $facts['os_service_default'].
#
# DEPRECATED PARAMETERS
#
# [*topic*]
#   (Optional) RPC topic name for mdns.
#   Defaults to undef.
#
# [*all_tcp*]
#   (Optional) Send all traffic over TCP.
#   Defaults to undef.
#
# [*xfr_timeout*]
#   (Optional) Timeout in seconds for XFR's.
#   Defaults to undef.
#
class designate::mdns (
  $package_ensure         = present,
  $mdns_package_name      = $::designate::params::mdns_package_name,
  Boolean $enabled        = true,
  Boolean $manage_service = true,
  $workers                = $facts['os_workers'],
  $threads                = $facts['os_service_default'],
  $tcp_backlog            = $facts['os_service_default'],
  $tcp_recv_timeout       = $facts['os_service_default'],
  $query_enforce_tsig     = $facts['os_service_default'],
  $storage_driver         = $facts['os_service_default'],
  $max_message_size       = $facts['os_service_default'],
  $listen                 = $facts['os_service_default'],
  # DEPRECATED PARAMETERS
  $topic                  = undef,
  $all_tcp                = undef,
  $xfr_timeout            = undef,
) inherits designate::params {

  include designate::deps
  include designate::db

  if $topic != undef {
    warning('The topic parameter is deprecated and has no effect')
  }

  ['all_tcp', 'xfr_timeout'].each |$opt| {
    if getvar($opt) != undef {
      warning("The designate::mdns::${opt} parameter is deprecated and has no effect. \
Use the designate::worker::${opt} parameter instead.")
    }
  }

  designate_config {
    'service:mdns/workers'            : value => $workers;
    'service:mdns/threads'            : value => $threads;
    'service:mdns/tcp_backlog'        : value => $tcp_backlog;
    'service:mdns/tcp_recv_timeout'   : value => $tcp_recv_timeout;
    'service:mdns/query_enforce_tsig' : value => $query_enforce_tsig;
    'service:mdns/storage_driver'     : value => $storage_driver;
    'service:mdns/max_message_size'   : value => $max_message_size;
    'service:mdns/listen'             : value => join(any2array($listen), ',');
  }

  # TODO(tkajinam): Remove this after 2024.1 release.
  designate_config {
    'service:mdns/all_tcp'     : ensure => absent;
    'service:mdns/topic'       : ensure => absent;
    'service:mdns/xfr_timeout' : ensure => absent;
  }

  designate::generic_service { 'mdns':
    enabled        => $enabled,
    manage_service => $manage_service,
    package_ensure => $package_ensure,
    package_name   => $mdns_package_name,
    service_name   => $::designate::params::mdns_service_name,
  }
}
