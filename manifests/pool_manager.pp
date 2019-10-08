# == Class: designate::pool_manager
#
# DEPRECATED!
#
# Configure designate pool manager service
#
# == Parameters
#
# [*pool_id*]
#  UUID of the pool to use.
#
# [*package_ensure*]
#  (optional) The state of the package
#  Defaults to 'present'
#
# [*manage_package*]
#   Whether Puppet should manage the package. Default is true.
#
# [*pool_manager_package_name*]
#  (optional) Name of the package containing pool manager
#  resources. Defaults to pool_manager_package_name from
#  designate::params
#
# [*enabled*]
#   (optional) Whether to enable services.
#   Defaults to true
#
# [*service_ensure*]
#   (optional) Whether the designate pool manager service will
#   be running.
#   Defaults to 'running'
#
# [*workers*]
#   (optional) Number of worker processes.
#   Defaults to $::os_workers
#
# [*threads*]
#   (optional) Number of Pool Manager greenthreads to spawn
#   Defaults to $::os_service_default
#
# [*threshold_percentage*]
#   (optional) Threshold percentage.
#   Defaults to $::os_service_default
#
# [*poll_timeout*]
#   (optional) Poll timeout.
#   Defaults to $::os_service_default
#
# [*poll_retry_interval*]
#   (optional) Poll retry interval.
#   Defaults to $::os_service_default
#
# [*poll_max_retries*]
#   (optional) Poll max retries.
#   Defaults to $::os_service_default
#
# [*poll_delay*]
#   (optional) Poll delay.
#   Defaults to $::os_service_default
#
# [*enable_recovery_timer*]
#   (optional) Enable the recovery thread
#   Defaults to $::os_service_default
#
# [*periodic_recovery_interval*]
#   (optional) Periodic recovery interval.
#   Defaults to $::os_service_default
#
# [*enable_sync_timer*]
#   (optional) Enable the sync thread
#   Defaults to $::os_service_default
#
# [*periodic_sync_interval*]
#   (optional) Periodic sync interval.
#   Defaults to $::os_service_default
#
# [*periodic_sync_seconds*]
#   (optional) Periodic sync seconds.
#   Defaults to $::os_service_default
#
# [*periodic_sync_max_attempts*]
#   (optional) Zones Updated within last N seconds will be syncd. Use None to sync all zones
#   Defaults to $::os_service_default
#
# [*periodic_sync_retry_interval*]
#   (optional) Perform multiple update attempts during periodic_sync
#   Defaults to $::os_service_default
#
class designate::pool_manager(
  $pool_id,
  $manage_package               = true,
  $package_ensure               = present,
  $pool_manager_package_name    = undef,
  $enabled                      = true,
  $service_ensure               = 'running',
  $workers                      = $::os_workers,
  $threads                      = $::os_service_default,
  $threshold_percentage         = $::os_service_default,
  $poll_timeout                 = $::os_service_default,
  $poll_retry_interval          = $::os_service_default,
  $poll_max_retries             = $::os_service_default,
  $poll_delay                   = $::os_service_default,
  $enable_recovery_timer        = $::os_service_default,
  $periodic_recovery_interval   = $::os_service_default,
  $enable_sync_timer            = $::os_service_default,
  $periodic_sync_interval       = $::os_service_default,
  $periodic_sync_seconds        = $::os_service_default,
  $periodic_sync_max_attempts   = $::os_service_default,
  $periodic_sync_retry_interval = $::os_service_default,
) {

  warning('designate::pool_manager is deprecated, has no effect and will be removed in the next release')
}
