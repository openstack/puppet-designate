# == Class designate::sink
#
# Configure designate sink service
#
# == Parameters
#
# [*package_ensure*]
#  (optional) The state of the package
#  Defaults to 'present'
#
# [*sink_package_name*]
#  (optional) Name of the package containing sink resources
#  Defaults to sink_package_name from designate::params
#
# [*enabled*]
#   (optional) Whether to enable services.
#   Defaults to true
#
# [*service_ensure*]
#  (optional) Whether the designate sink service will be running.
#  Defaults to 'running'
#
class designate::sink (
  $package_ensure    = present,
  $sink_package_name = undef,
  $enabled           = true,
  $service_ensure    = 'running',
) {
  include ::designate::params

  package { 'designate-sink':
    ensure => $package_ensure,
    name   => pick($sink_package_name, $::designate::params::sink_service_name),
    tag    => 'openstack',
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
