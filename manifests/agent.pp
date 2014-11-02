# == Class designate::agent
#
# Configure designate agent service
#
# == Parameters
#
# [*enabled*]
#   (optional) Whether to enable services.
#   Defaults to true
#
# [*service_ensure*]
#  (optional) Whether the designate api service will be running.
#  Defaults to 'running'
#
# [*backend_driver*]
#  (optional) Driver used for backend communication (fake, rpc, bind9, powerdns)
#  Defaults to 'bind9'
#
class designate::agent (
  $service_ensure = 'running',
  $backend_driver = 'bind9',
  $enabled        = true,
) {
  include designate::params

  package { 'designate-agent':
    ensure => installed,
    name   => $::designate::params::agent_package_name,
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
