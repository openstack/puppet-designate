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
#   Defaults to $::os_service_default.
#
# [*threads*]
#   (Optional) Number of mdns greenthreads to spawn.
#   Defaults to $::os_service_default.
#
# [*host*]
#   (Optional) mDNS Bind Host.
#   Defaults to $::os_service_default.
#
# [*port*]
#   (Optional) mDNS Port Number.
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
class designate::mdns (
  $package_ensure     = present,
  $mdns_package_name  = $::designate::params::mdns_package_name,
  $enabled            = true,
  $manage_service     = 'running',
  $workers            = $::os_service_default,
  $threads            = $::os_service_default,
  $host               = $::os_service_default,
  $port               = $::os_service_default,
  $tcp_backlog        = $::os_service_default,
  $tcp_recv_timeout   = $::os_service_default,
  $query_enforce_tsig = $::os_service_default,
  $storage_driver     = $::os_service_default,
  $max_message_size   = $::os_service_default
) inherits designate {

  designate_config {
    'service:mdns/workers'            : value => $workers;
    'service:mdns/threads'            : value => $threads;
    'service:mdns/host'               : value => $host;
    'service:mdns/port'               : value => $port;
    'service:mdns/tcp_backlog'        : value => $tcp_backlog;
    'service:mdns/tcp_recv_timeout'   : value => $tcp_recv_timeout;
    'service:mdns/query_enforce_tsig' : value => $query_enforce_tsig;
    'service:mdns/storage_driver'     : value => $storage_driver;
    'service:mdns/max_message_size'   : value => $max_message_size;
  }

  designate::generic_service { 'mdns':
    enabled        => $enabled,
    manage_service => $manage_service,
    ensure_package => $package_ensure,
    package_name   => $mdns_package_name,
    service_name   => $::designate::params::mdns_service_name,
  }
}
