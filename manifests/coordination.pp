# == Class: designate::coordination
#
# Setup and configure Designate coordination settings.
#
# === Parameters
#
# [*backend_url*]
#   (Optional) Coordination backend URL.
#   Defaults to $::os_service_default
#
# [*heartbeat_interval*]
#   (Optional) Number of seconds between hearbeats for distributed
#   coordintation.
#   Defaults to $::os_service_default
#
# [*run_watchers_interval*]
#   (Optional) Numeber of seconds between checks to see if group membership
#   has changed.
#   Defaults to $::os_service_default
#
class designate::coordination (
  $backend_url           = $::os_service_default,
  $heartbeat_interval    = $::os_service_default,
  $run_watchers_interval = $::os_service_default,
) {

  include designate::deps

  $backend_url_real = pick($::designate::producer::backend_url, $backend_url)

  oslo::coordination{ 'designate_config':
    backend_url => $backend_url_real
  }

  designate_config {
    'coordination/heartbeat_interval':    value => $heartbeat_interval;
    'coordination/run_watchers_interval': value => $run_watchers_interval;
  }
}
