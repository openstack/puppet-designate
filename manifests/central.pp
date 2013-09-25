class designate::central (
  $enabled        = true,
  $backend_driver = 'bind9',
) {
  include designate::params

  package { 'designate-api':
    ensure => installed,
    name   => $::designate::params::central_package_name,
  }

  Package['designate-common'] -> Service['designate-api']

  service { 'designate-api':
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
