# == Class designate::central
#
# Configure designate central service
#
# == Parameters
#
# [*package_ensure*]
#  (optional) The state of the package
#  Defaults to 'present'
#
# [*central_package_name*]
#  (optional) Name of the package containing central resources
#  Defaults to central_package_name from designate::params
#
# [*enabled*]
#   (optional) Whether to enable services.
#   Defaults to true
#
# [*service_ensure*]
#  (optional) Whether the designate central service will be running.
#  Defaults to 'running'
#
# [*backend_driver*]
#  (optional) Driver used for backend communication (fake, rpc, bind9, powerdns)
#  Defaults to 'bind9'
#
class designate::central (
  $package_ensure       = present,
  $central_package_name = undef,
  $enabled              = true,
  $service_ensure       = 'running',
  $backend_driver       = 'bind9',
) {
  include ::designate::params

  package { 'designate-central':
    ensure => $package_ensure,
    name   => pick($central_package_name, $::designate::params::central_package_name),
    tag    => 'openstack',
  }

  Designate_config<||> ~> Service['designate-central']
  Package['designate-central'] -> Designate_config<||>

  service { 'designate-central':
    ensure     => $service_ensure,
    name       => $::designate::params::central_service_name,
    enable     => $enabled,
    hasstatus  => true,
    hasrestart => true,
    require    => Class['::designate::db'],
    subscribe  => Exec['designate-dbsync']
  }

  designate_config {
    'service:central/backend_driver'         : value => $backend_driver;
  }
}
