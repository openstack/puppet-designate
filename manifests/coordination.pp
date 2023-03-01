# == Class: designate::coordination
#
# Setup and configure Designate coordination settings.
#
# === Parameters
#
# [*backend_url*]
#   (Optional) Coordination backend URL.
#   Defaults to $facts['os_service_default']
#
# [*heartbeat_interval*]
#   (Optional) Number of seconds between heartbeats for distributed
#   coordination.
#   Defaults to $facts['os_service_default']
#
# [*run_watchers_interval*]
#   (Optional) Number of seconds between checks to see if group membership
#   has changed.
#   Defaults to $facts['os_service_default']
#
class designate::coordination (
  $backend_url           = $facts['os_service_default'],
  $heartbeat_interval    = $facts['os_service_default'],
  $run_watchers_interval = $facts['os_service_default'],
) {

  include designate::deps

  oslo::coordination{ 'designate_config':
    backend_url => $backend_url
  }

  designate_config {
    'coordination/heartbeat_interval':    value => $heartbeat_interval;
    'coordination/run_watchers_interval': value => $run_watchers_interval;
  }
}
