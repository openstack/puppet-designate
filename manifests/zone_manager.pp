# == Class designate::zone_manager
#
# Configure designate zone manager service
#
# == Parameters
#
# [*package_ensure*]
#  (optional) The state of the package
#  Defaults to 'present'
#
# [*package_name*]
#  (optional) Name of the package
#  Defaults to zone_manager_package_name from ::designate::params
#
# [*enabled*]
#  (optional) Whether to enable the service.
#  Defaults to true
#
# [*service_ensure*]
#  (optional) Whether the designate zone manager service will be running.
#  Defaults to 'running'
#
# [*workers*]
#  (optional) Number of workers to spawn.
#  Defaults to $::os_workers.
#
# [*threads*]
#  (optional) Number of greenthreads to spawn
#  Defaults to $::os_service_default.
#
# [*enabled_tasks*]
#  (optional) List of tasks to enable, the default enables all tasks.
#  Defaults to $::os_service_default.
#
# [*export_synchronous*]
#  (optional) Whether to allow synchronous zone exports
#  Defaults to $::os_service_default.
#
class designate::zone_manager (
  $package_ensure            = 'present',
  $package_name              = $::designate::params::zone_manager_package_name,
  $enabled                   = true,
  $service_ensure            = running,
  $workers                   = $::os_workers,
  $threads                   = $::os_service_default,
  $enabled_tasks             = $::os_service_default,
  $export_synchronous        = $::os_service_default,
  ) inherits designate {

  designate_config {
    'service:zone_manager/workers'            : value => $workers;
    'service:zone_manager/threads'            : value => $threads;
    'service:zone_manager/enabled_tasks'      : value => $enabled_tasks;
    'service:zone_manager/export_synchronous' : value => $export_synchronous;
  }

  designate::generic_service { 'zone-manager':
    package_ensure => $package_ensure,
    enabled        => $enabled,
    package_name   => $package_name,
    manage_service => $service_ensure,
    service_name   => $::designate::params::zone_manager_service_name,
  }
}
