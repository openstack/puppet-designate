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
#   (Optional) Whether the designate mdns service will be running.
#   Defaults to 'running'.
#
# [*workers*]
#   (Optional) Number of mdns worker processes to spawn.
#   Defaults to $::os_workers.
#
# [*threads*]
#   (Optional) Number of mdns greenthreads to spawn.
#   Defaults to $::os_service_default.
#
# [*tcp_backlog*]
#   (Optional) mDNS TCP Backlog.
#   Defaults to $::os_service_default.
#
# [*tcp_recv_timeout*]
#   (Optional) mDNS TCP Receive Timeout.
#   Defaults to $::os_service_default.
#
# [*query_enforce_tsig*]
#   (Optional) Enforce all incoming queries (including AXFR) are TSIG signed.
#   Defaults to $::os_service_default.
#
# [*storage_driver*]
#   (Optional) The storage driver to use.
#   Defaults to $::os_service_default.
#
# [*max_message_size*]
#   (Optional) Maximum message size to emit.
#   Defaults to $::os_service_default.
#
# [*listen*]
#   (Optional) mDNS host:port pairs to listen on.
#   Defaults to $::os_service_default.
#
class designate::mdns (
  $package_ensure     = present,
  $mdns_package_name  = $::designate::params::mdns_package_name,
  $enabled            = true,
  $manage_service     = 'running',
  $workers            = $::os_workers,
  $threads            = $::os_service_default,
  $tcp_backlog        = $::os_service_default,
  $tcp_recv_timeout   = $::os_service_default,
  $query_enforce_tsig = $::os_service_default,
  $storage_driver     = $::os_service_default,
  $max_message_size   = $::os_service_default,
  $listen             = $::os_service_default,
) inherits designate {

  include ::designate::deps

  designate_config {
    'service:mdns/workers'            : value => $workers;
    'service:mdns/threads'            : value => $threads;
    'service:mdns/tcp_backlog'        : value => $tcp_backlog;
    'service:mdns/tcp_recv_timeout'   : value => $tcp_recv_timeout;
    'service:mdns/query_enforce_tsig' : value => $query_enforce_tsig;
    'service:mdns/storage_driver'     : value => $storage_driver;
    'service:mdns/max_message_size'   : value => $max_message_size;
    'service:mdns/listen'             : value => $listen;
  }

  designate::generic_service { 'mdns':
    enabled        => $enabled,
    manage_service => $manage_service,
    package_ensure => $package_ensure,
    package_name   => $mdns_package_name,
    service_name   => $::designate::params::mdns_service_name,
  }
}
