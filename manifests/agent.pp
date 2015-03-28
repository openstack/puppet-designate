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
#  Defaults to agent_package_name from designate::params
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
class designate::agent (
  $package_ensure     = present,
  $agent_package_name = undef,
  $enabled            = true,
  $service_ensure     = 'running',
  $backend_driver     = 'bind9',
) {
  include ::designate::params

  package { 'designate-agent':
    ensure => $package_ensure,
    name   => pick($agent_package_name, $::designate::params::agent_package_name),
    tag    => 'openstack',
  }

  Designate_config<||> ~> Service['designate-agent']
  Package['designate-agent'] -> Designate_config<||>

  service { 'designate-agent':
    ensure     => $service_ensure,
    name       => $::designate::params::agent_service_name,
    enable     => $enabled,
    hasstatus  => true,
    hasrestart => true,
  }

  designate_config {
    'service:agent/backend_driver'         : value => $backend_driver;
  }
}
