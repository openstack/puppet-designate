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
# [*listen*]
#  (optional) Agent host:port pairs to listen on.
#  Defaults to $::os_service_default
#
# DEPRECATED PARAMETERS
#
# [*service_ensure*]
#  (optional) Whether the designate agent service will be running.
#  Defaults to 'DEPRECATED'
#
class designate::agent (
  $package_ensure     = present,
  $agent_package_name = $::designate::params::agent_package_name,
  $enabled            = true,
  $manage_service     = true,
  $backend_driver     = 'bind9',
  $listen             = $::os_service_default,
  # DEPRECATED PARAMETERS
  $service_ensure     = 'DEPRECATED',
) inherits designate {

  include designate::deps

  if $service_ensure != 'DEPRECATED' {
    warning('The service_ensure parameter is deprecated. Use the manage_service parameter.')
    $manage_service_real = $service_ensure
  } else {
    $manage_service_real = $manage_service
  }

  designate_config {
    'service:agent/backend_driver' : value => $backend_driver;
    'service:agent/listen' :         value => $listen;
  }

  designate::generic_service { 'agent':
    enabled        => $enabled,
    manage_service => $manage_service_real,
    package_ensure => $package_ensure,
    package_name   => $agent_package_name,
    service_name   => $::designate::params::agent_service_name,
  }
}
