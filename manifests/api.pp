class designate::api (
  $enabled                    = true,
  $service_ensure             = 'running',
  $auth_strategy              = 'noauth',
  $keystone_host              = '127.0.0.1',
  $keystone_port              = '35357',
  $keystone_auth_admin_prefix = false,
  $keystone_protocol          = 'http',
  $keystone_user              = 'ceilometer',
  $keystone_tenant            = 'services',
  $keystone_password          = false,
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
