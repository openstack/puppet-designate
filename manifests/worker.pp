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
# [*manage_package*]
#   Whether Puppet should manage the package. Default is true.
#
# [*worker_package_name*]
#  (optional) Name of the package containing worker
#  resources. Defaults to worker_package_name from
#  designate::params
#
# [*enabled*]
#   (optional) Whether to enable services.
#   Defaults to true
#
# [*service_ensure*]
#   (optional) Whether the designate worker service will
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
# [*worker_notify*]
#   (optional) Whether to allow worker to send NOTIFYs.
#   Defaults to $::os_service_default
#
# [*export_synchronous*]
#   (optional) Whether to allow synchronous zone exports.
#   Defaults to $::os_service_default
#
# [*worker_topic*]
#   (optional) RPC topic for worker component.
#   Defaults to $::os_service_default
#
class designate::worker(
  $manage_package       = true,
  $package_ensure       = present,
  $worker_package_name  = undef,
  $enabled              = true,
  $service_ensure       = 'running',
  $workers              = $::os_workers,
  $threads              = $::os_service_default,
  $threshold_percentage = $::os_service_default,
  $poll_timeout         = $::os_service_default,
  $poll_retry_interval  = $::os_service_default,
  $poll_max_retries     = $::os_service_default,
  $poll_delay           = $::os_service_default,
  $worker_notify        = $::os_service_default,
  $export_synchronous   = $::os_service_default,
  $worker_topic         = $::os_service_default,
) {

  include ::designate::deps
  include ::designate::params

  if $manage_package {
    package { 'designate-worker':
      ensure => $package_ensure,
      name   => pick($worker_package_name, $::designate::params::worker_package_name),
      tag    => ['openstack', 'designate-package'],
    }
  }

  service { 'designate-worker':
    ensure     => $service_ensure,
    name       => $::designate::params::worker_service_name,
    enable     => $enabled,
    hasstatus  => true,
    hasrestart => true,
    tag        => ['openstack', 'designate-service'],
  }

  designate_config {
    'service:worker/workers':              value => $workers;
    'service:worker/threads':              value => $threads;
    'service:worker/threshold_percentage': value => $threshold_percentage;
    'service:worker/poll_timeout':         value => $poll_timeout;
    'service:worker/poll_retry_interval':  value => $poll_retry_interval;
    'service:worker/poll_max_retries':     value => $poll_max_retries;
    'service:worker/poll_delay':           value => $poll_delay;
    'service:worker/notify':               value => $worker_notify;
    'service:worker/export_synchronous':   value => $export_synchronous;
    'service:worker/worker_topic':         value => $worker_topic;
    'service:worker/enabled':              value => $enabled;
  }
}
