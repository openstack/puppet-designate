# == Class designate::producer
#
# Configure designate producer service
#
# == Parameters
#
# [*package_ensure*]
#  (optional) The state of the package
#  Defaults to 'present'
#
# [*package_name*]
#  (optional) Name of the package
#  Defaults to producer_package_name from ::designate::params
#
# [*enabled*]
#  (optional) Whether to enable the service.
#  Defaults to true
#
# [*manage_service*]
#   (Optional) Whether the designate producer service will be managed.
#   Defaults to true.
#
# [*workers*]
#  (optional) Number of workers to spawn.
#  Defaults to $facts['os_workers'].
#
# [*threads*]
#  (optional) Number of greenthreads to spawn
#  Defaults to $facts['os_service_default'].
#
# [*enabled_tasks*]
#  (optional) List of tasks to enable, the default enables all tasks.
#  Defaults to $facts['os_service_default'].
#
class designate::producer (
  $package_ensure = 'present',
  $package_name   = $::designate::params::producer_package_name,
  $enabled        = true,
  $manage_service = true,
  $workers        = $facts['os_workers'],
  $threads        = $facts['os_service_default'],
  $enabled_tasks  = $facts['os_service_default'],
) inherits designate::params {

  include designate::deps

  validate_legacy(Boolean, 'validate_bool', $manage_service)
  validate_legacy(Boolean, 'validate_bool', $enabled)

  designate_config {
    'service:producer/workers'       : value => $workers;
    'service:producer/threads'       : value => $threads;
    'service:producer/enabled_tasks' : value => join(any2array($enabled_tasks), ',');
  }

  designate::generic_service { 'producer':
    package_ensure => $package_ensure,
    enabled        => $enabled,
    package_name   => $package_name,
    manage_service => $manage_service,
    service_name   => $::designate::params::producer_service_name,
  }
}
