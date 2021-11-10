# == Class designate::agent
#
# Configure designate agent service
#
# == Parameters
#
# [*package_ensure*]
#  (optional) The state of the package
#  Defaults to 'present'
#
# [*agent_package_name*]
#  (optional) Name of the package containing agent resources
#  Defaults to $::designate::params::agent_package_name
#
# [*enabled*]
#   (optional) Whether to enable services.
#   Defaults to true
#
# [*manage_service*]
#   (Optional) Whether the designate agent service will be managed.
#   Defaults to true.
#
# [*backend_driver*]
#  (optional) Driver used for backend communication (fake, rpc, bind9)
#  Defaults to 'bind9'
#
# [*workers*]
#  (optional) Number of agent worker process to spawn
#  Defaults to $::os_workers
#
# [*threads*]
#  (optional) Number of agent greenthreads to spawn
#  Defaults to $::os_service_default
#
# [*listen*]
#  (optional) Agent host:port pairs to listen on.
#  Defaults to $::os_service_default
#
class designate::agent (
  $package_ensure     = present,
  $agent_package_name = $::designate::params::agent_package_name,
  $enabled            = true,
  $manage_service     = true,
  $backend_driver     = 'bind9',
  $workers            = $::os_workers,
  $threads            = $::os_service_default,
  $listen             = $::os_service_default,
) inherits designate {

  include designate::deps

  designate_config {
    'service:agent/backend_driver' : value => $backend_driver;
    'service:agent/workers' :        value => $workers;
    'service:agent/threads' :        value => $threads;
    'service:agent/listen' :         value => $listen;
  }

  designate::generic_service { 'agent':
    enabled        => $enabled,
    manage_service => $manage_service,
    package_ensure => $package_ensure,
    package_name   => $agent_package_name,
    service_name   => $::designate::params::agent_service_name,
  }
}
