# Designate agent

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

  Package['designate-common'] -> Service['designate-agent']

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
