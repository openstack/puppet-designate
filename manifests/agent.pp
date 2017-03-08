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
# [*service_ensure*]
#  (optional) Whether the designate agent service will be running.
#  Defaults to 'running'
#
# [*backend_driver*]
#  (optional) Driver used for backend communication (fake, rpc, bind9, powerdns)
#  Defaults to 'bind9'
#
# [*listen*]
#  (optional) Agent host:port pairs to listen on.
#  Defaults to $::os_service_default
#
class designate::agent (
  $package_ensure     = present,
  $agent_package_name = $::designate::params::agent_package_name,
  $enabled            = true,
  $service_ensure     = 'running',
  $backend_driver     = 'bind9',
  $listen             = $::os_service_default,
) inherits designate {

  include ::designate::deps

  designate_config {
    'service:agent/backend_driver' : value => $backend_driver;
    'service:agent/listen' :         value => $listen;
  }

  designate::generic_service { 'agent':
    enabled        => $enabled,
    manage_service => $service_ensure,
    package_ensure => $package_ensure,
    package_name   => $agent_package_name,
    service_name   => $::designate::params::agent_service_name,
  }
}
