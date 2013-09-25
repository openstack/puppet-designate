class designate::api (
  $enabled        = true,
  $auth_strategy  = 'noauth',
){
  include designate::params

  package { 'designate-api':
    ensure => installed,
    name   => $::designate::params::api_package_name,
  }

  Package['designate-common'] -> Service['designate-api']

  service { 'designate-api':
    ensure     => $service_ensure,
    name       => $::designate::params::api_service_name,
    enable     => $enabled,
    hasstatus  => true,
    hasrestart => true,
    require    => Class['designate::db'],
    subscribe  => Exec['designate-dbsync']
  }

  designate_config {
    'service:api/auth_strategy'         : value => $auth_strategy;
  }


}
