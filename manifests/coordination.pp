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
# [*manage_backend_package*]
#   (Optional) Whether to install the backend package.
#   Defaults to true.
#
# [*package_ensure*]
#   (Optional) ensure state for package.
#   Defaults to 'present'
#
class designate::coordination (
  $backend_url                            = $facts['os_service_default'],
  $heartbeat_interval                     = $facts['os_service_default'],
  $run_watchers_interval                  = $facts['os_service_default'],
  Boolean $manage_backend_package         = true,
  Stdlib::Ensure::Package $package_ensure = present,
) {
  include designate::deps

  oslo::coordination { 'designate_config':
    backend_url            => $backend_url,
    manage_backend_package => $manage_backend_package,
    package_ensure         => $package_ensure,
  }

  designate_config {
    'coordination/heartbeat_interval':    value => $heartbeat_interval;
    'coordination/run_watchers_interval': value => $run_watchers_interval;
  }

  # all coordination settings should be applied and all packages should be
  # installed before service startup
  Oslo::Coordination['designate_config'] -> Anchor['designate::service::begin']
}
