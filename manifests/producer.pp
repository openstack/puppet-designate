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
# DEPRECATED PARAMETERS
#
# [*backend_url*]
#  (optional) URL to use for coordination, should be a tooz URL.
#  Defaults to undef
#
# [*service_ensure*]
#  (optional) Whether the designate producer service will be running.
#  Defaults to 'DEPRECATED'
#
class designate::producer (
  $package_ensure = 'present',
  $package_name   = $::designate::params::producer_package_name,
  $enabled        = true,
  $manage_service = true,
  $workers        = $::os_workers,
  $threads        = $::os_service_default,
  $enabled_tasks  = $::os_service_default,
  # DEPRECATED PARAMETERS
  $backend_url    = undef,
  $service_ensure = 'DEPRECATED',

  ) inherits designate {

  if $service_ensure != 'DEPRECATED' {
    warning('The service_ensure parameter is deprecated. Use the manage_service parameter.')
    $manage_service_real = $service_ensure
  } else {
    $manage_service_real = $manage_service
  }

  designate_config {
    'service:producer/workers'       : value => $workers;
    'service:producer/threads'       : value => $threads;
    'service:producer/enabled_tasks' : value => $enabled_tasks;
  }

  if $backend_url != undef {
    warning('designate::producer::backend_url is deprecated. Use designate::coordination instead')
    include designate::coordination
  }

  designate::generic_service { 'producer':
    package_ensure => $package_ensure,
    enabled        => $enabled,
    package_name   => $package_name,
    manage_service => $manage_service_real,
    service_name   => $::designate::params::producer_service_name,
  }
}
