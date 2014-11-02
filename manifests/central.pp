# == Class designate::central
#
# Configure designate central service
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
class designate::central (
  $service_ensure = 'running',
  $enabled        = true,
  $backend_driver = 'bind9',
) {
  include designate::params

  package { 'designate-central':
    ensure => installed,
    name   => $::designate::params::central_package_name,
  }

  Designate_config<||> ~> Service['designate-central']
  Package['designate-central'] -> Designate_config<||>

  service { 'designate-central':
    ensure     => $service_ensure,
    name       => $::designate::params::central_service_name,
    enable     => $enabled,
    hasstatus  => true,
    hasrestart => true,
    require    => Class['designate::db'],
    subscribe  => Exec['designate-dbsync']
  }

  designate_config {
    'service:central/backend_driver'         : value => $backend_driver;
  }
}
