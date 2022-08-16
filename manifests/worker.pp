# == Class: designate::worker
#
# Configure designate worker service
#
# == Parameters
#
# [*package_ensure*]
#  (optional) The state of the package
#  Defaults to 'present'
#
# [*worker_package_name*]
#  (optional) Name of the package containing worker resources.
#  Defaults to worker_package_name from designate::params
#
# [*enabled*]
#   (optional) Whether to enable services.
#   Defaults to true
#
# [*manage_service*]
#   (Optional) Whether the designate worker service will be managed.
#   Defaults to true.
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
# [*export_synchronous*]
#   (optional) Whether to allow synchronous zone exports.
#   Defaults to $::os_service_default
#
# [*topic*]
#   (optional) RPC topic for worker component.
#   Defaults to $::os_service_default
#
# DEPRECATED PARAMETERS
#
# [*manage_package*]
#   Whether Puppet should manage the package.
#   Default is undef.
#
# [*service_ensure*]
#   (optional) Whether the designate worker service will
#   be running.
#   Defaults to undef
#
# [*worker_topic*]
#   (optional) RPC topic for worker component.
#   Defaults to undef
#
class designate::worker(
  $package_ensure       = present,
  $worker_package_name  = $::designate::params::worker_package_name,
  $enabled              = true,
  $manage_service       = true,
  $workers              = $::os_workers,
  $threads              = $::os_service_default,
  $threshold_percentage = $::os_service_default,
  $poll_timeout         = $::os_service_default,
  $poll_retry_interval  = $::os_service_default,
  $poll_max_retries     = $::os_service_default,
  $poll_delay           = $::os_service_default,
  $export_synchronous   = $::os_service_default,
  $topic                = $::os_service_default,
  # DEPRECATED PARAMETERS
  $manage_package       = undef,
  $service_ensure       = undef,
  $worker_topic         = undef,
) inherits designate::params {

  include designate::deps

  if $manage_package != undef {
    warning('manage_package is deprecated and has no effect')
  }

  if $service_ensure != undef {
    warning('service_ensure is deprecated and has no effect')
  }

  if $worker_topic != undef {
    warning('The worker_topic parameter is deprecated. Use the topic parameter instead.')
  }

  designate::generic_service { 'worker':
    package_ensure => $package_ensure,
    enabled        => $enabled,
    package_name   => $worker_package_name,
    manage_service => $manage_service,
    service_name   => $::designate::params::worker_service_name,
  }

  designate_config {
    'service:worker/workers':              value => $workers;
    'service:worker/threads':              value => $threads;
    'service:worker/threshold_percentage': value => $threshold_percentage;
    'service:worker/poll_timeout':         value => $poll_timeout;
    'service:worker/poll_retry_interval':  value => $poll_retry_interval;
    'service:worker/poll_max_retries':     value => $poll_max_retries;
    'service:worker/poll_delay':           value => $poll_delay;
    'service:worker/export_synchronous':   value => $export_synchronous;
    'service:worker/topic':                value => pick($worker_topic, $topic);
  }

  # TODO(tkajinam): Remove this after Zed release
  designate_config {
    'service:worker/worker_topic': ensure => absent;
  }
}
