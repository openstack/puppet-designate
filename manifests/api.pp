# class designate::api

class designate::api (
  $enabled                    = true,
  $service_ensure             = 'running',
  $auth_strategy              = 'noauth',
  $keystone_host              = '127.0.0.1',
  $keystone_port              = '35357',
  $keystone_protocol          = 'http',
  $keystone_tenant            = 'services',
  $keystone_user              = 'designate',
  $keystone_password          = false,
  $enable_api_v1              = true,
  $enable_api_v2              = false,
){
  include designate::params

  package { 'designate-api':
    ensure => installed,
    name   => $::designate::params::api_package_name,
  }

  Designate_config<||> ~> Service['designate-api']
  Package['designate-api'] -> Designate_config<||>

  service { 'designate-api':
    ensure     => $service_ensure,
    name       => $::designate::params::api_service_name,
    enable     => $enabled,
    hasstatus  => true,
    hasrestart => true,
    require    => Class['designate::db'],
    subscribe  => Exec['designate-dbsync']
  }

  # API Service
  designate_config {
    'service:api/auth_strategy'             : value => $auth_strategy;
    'service:api/enable_api_v1'             : value => $enable_api_v1;
    'service:api/enable_api_v2'             : value => $enable_api_v2;
  }

  # Keystone Middleware
  designate_config {
    'keystone_authtoken/auth_host'          : value => $keystone_host;
    'keystone_authtoken/auth_port'          : value => $keystone_port;
    'keystone_authtoken/auth_protocol'      : value => $keystone_protocol;
    'keystone_authtoken/admin_tenant_name'  : value => $keystone_tenant;
    'keystone_authtoken/admin_user'         : value => $keystone_user;
    'keystone_authtoken/admin_password'     : value => $keystone_password, secret => true;
  }

}
