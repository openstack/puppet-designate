# == Class designate::api
#
# Configure designate API service
#
# == Parameters
#
# [*package_ensure*]
#  (optional) The state of the package
#  Defaults to 'present'
#
# [*api_package_name*]
#  (optional) Name of the package containing api resources
#  Defaults to $designate::params::api_package_name
#
# [*enabled*]
#   (optional) Whether to enable services.
#   Defaults to true
#
# [*manage_service*]
#   (Optional) Whether the designate api service will be managed.
#   Defaults to true
#
# [*auth_strategy*]
#  (optional) Authentication strategy to use, can be either "noauth" or
#  "keystone".
#  Defaults to $facts['os_service_default']
#
# [*enable_api_v2*]
#  (optional) Enable Designate API Version 2.
#  Defaults to $facts['os_service_default']
#
# [*enable_api_admin*]
#  (optional) Enable Designate Admin API.
#  Defaults to $facts['os_service_default']
#
# [*api_base_uri*]
#  Set the base URI of the Designate API service.
#
# [*listen*]
#  (optional) API host:port pairs to listen on.
#  Defaults to $facts['os_service_default']
#
# [*workers*]
#  (optional) Number of api worker processes to spawn.
#  Defaults to $facts['os_workers']
#
# [*threads*]
#  (optional) Number of api greenthreads to spawn.
#  Defaults to $facts['os_service_default']
#
# [*enable_host_header*]
#  (optional) Enable host request headers.
#  Defaults to $facts['os_service_default']
#
# [*max_header_line*]
#  (optional) Maximum line size of message headers to be accepted.
#  Defaults to $facts['os_service_default']
#
# [*default_limit_admin*]
#  (optional) Default per-page limit for the Admin API.
#  Defaults to $facts['os_service_default']
#
# [*max_limit_admin*]
#  (optional) Max page size in the Admin API.
#  Defaults to $facts['os_service_default']
#
# [*default_limit_v2*]
#  (optional) Default per-page limit for the V2 API.
#  Defaults to $facts['os_service_default']
#
# [*max_limit_v2*]
#  (optional) Max page size in the V2 API.
#  Defaults to $facts['os_service_default']
#
# [*pecan_debug*]
#  (optional) Show the pecan HTML based debug interface (v2 only).
#  Defaults to $facts['os_service_default']
#
# [*enabled_extensions_v2*]
#  (optional) API Version 2 extensions.
#  Defaults to $facts['os_service_default']
#
# [*enabled_extensions_admin*]
#  (optional) Admin API extensions.
#  Defaults to $facts['os_service_default']
#
# [*quotas_verify_project_id*]
#   (Optional) Verify that the requested Project ID for quota target is
#   a valid project in Keystone.
#   Defaults to $facts['os_service_default'].
#
# [*enable_proxy_headers_parsing*]
#   (Optional) Enable paste middleware to handle SSL requests through
#   HTTPProxyToWSGI middleware.
#   Defaults to $facts['os_service_default'].
#
# [*max_request_body_size*]
#   (Optional) Set max request body size
#   Defaults to $facts['os_service_default'].
#
# [*service_name*]
#   (Optional) Name of the service that will be providing the server
#   functionality of the designate API. If the value is 'httpd',
#   designate will be run as web service and configuration of the
#   web server will be required (e.g designate::wsgi::apache)
#   Defaults to $designate::params::api_service_name
#
class designate::api (
  $package_ensure               = present,
  $api_package_name             = $designate::params::api_package_name,
  Boolean $enabled              = true,
  Boolean $manage_service       = true,
  $auth_strategy                = $facts['os_service_default'],
  $enable_api_v2                = $facts['os_service_default'],
  $enable_api_admin             = $facts['os_service_default'],
  $api_base_uri                 = $facts['os_service_default'],
  $listen                       = $facts['os_service_default'],
  $workers                      = $facts['os_workers'],
  $threads                      = $facts['os_service_default'],
  $enable_host_header           = $facts['os_service_default'],
  $max_header_line              = $facts['os_service_default'],
  $default_limit_admin          = $facts['os_service_default'],
  $max_limit_admin              = $facts['os_service_default'],
  $default_limit_v2             = $facts['os_service_default'],
  $max_limit_v2                 = $facts['os_service_default'],
  $pecan_debug                  = $facts['os_service_default'],
  $enabled_extensions_v2        = $facts['os_service_default'],
  $enabled_extensions_admin     = $facts['os_service_default'],
  $quotas_verify_project_id     = $facts['os_service_default'],
  $enable_proxy_headers_parsing = $facts['os_service_default'],
  $max_request_body_size        = $facts['os_service_default'],
  $service_name                 = $designate::params::api_service_name,
) inherits designate {
  include designate::deps
  include designate::policy

  # API Service
  designate_config {
    'service:api/listen'                    : value => $listen;
    'service:api/auth_strategy'             : value => $auth_strategy;
    'service:api/enable_api_v2'             : value => $enable_api_v2;
    'service:api/enable_api_admin'          : value => $enable_api_admin;
    'service:api/api_base_uri'              : value => $api_base_uri;
    'service:api/workers'                   : value => $workers;
    'service:api/threads'                   : value => $threads;
    'service:api/enable_host_header'        : value => $enable_host_header;
    'DEFAULT/max_header_line'               : value => $max_header_line;
    'service:api/default_limit_admin'       : value => $default_limit_admin;
    'service:api/max_limit_admin'           : value => $max_limit_admin;
    'service:api/default_limit_v2'          : value => $default_limit_v2;
    'service:api/max_limit_v2'              : value => $max_limit_v2;
    'service:api/pecan_debug'               : value => $pecan_debug;
    'service:api/enabled_extensions_v2'     : value => join(any2array($enabled_extensions_v2), ',');
    'service:api/enabled_extensions_admin'  : value => join(any2array($enabled_extensions_admin), ',');
    'service:api/quotas_verify_project_id'  : value => $quotas_verify_project_id;
  }

  if $auth_strategy == 'keystone' {
    include designate::keystone::authtoken
  }

  oslo::middleware { 'designate_config':
    enable_proxy_headers_parsing => $enable_proxy_headers_parsing,
    max_request_body_size        => $max_request_body_size,
  }

  if $manage_service {
    if $service_name == 'httpd' {
      service { 'designate-api':
        ensure => 'stopped',
        name   => $designate::params::api_service_name,
        enable => false,
        tag    => ['designate-service'],
      }
      Service['designate-api'] -> Service[$service_name]
      $service_name_real = false
      Service <| title == 'httpd' |> { tag +> 'designate-service' }

      # On any paste-api.ini config change, we must restart Designate API.
      Designate_api_paste_ini<||> ~> Service[$service_name]
    } else {
      $service_name_real = $service_name

      # On any paste-api.ini config change, we must restart Designate API.
      Designate_api_paste_ini<||> ~> Service['designate-api']
      # On any uwsgi config change, we must restart Designate API.
      Designate_api_uwsgi_config<||> ~> Service['designate-api']
    }
  } else {
    $service_name_real = $service_name
  }

  designate::generic_service { 'api':
    enabled        => $enabled,
    manage_service => $manage_service,
    package_ensure => $package_ensure,
    package_name   => $api_package_name,
    service_name   => $service_name_real,
  }
}
