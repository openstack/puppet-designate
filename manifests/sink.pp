# == Class designate::sink
#
# Configure designate sink service
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
class designate::sink (
  $service_ensure = 'running',
  $enabled        = true,
) {
  include designate::params

  package { 'designate-sink':
    ensure => installed,
    name   => $::designate::params::sink_package_name,
  }

  Package['designate-sink'] -> Service['designate-sink']

  service { 'designate-sink':
    ensure     => $service_ensure,
    name       => $::designate::params::sink_service_name,
    enable     => $enabled,
    hasstatus  => true,
    hasrestart => true,
  }
}
