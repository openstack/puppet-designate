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
#  Defaults to $::designate::paramas::api_package_name
#
# [*enabled*]
#   (optional) Whether to enable services.
#   Defaults to true
#
# [*manage_service*]
#   (optional) Whether to manage services
#   Defaults to true
#
# [*auth_strategy*]
#  (optional) Authentication strategy to use, can be either "noauth" or
#  "keystone".
#  Defaults to $::os_service_default
#
# [*enable_api_v2*]
#  (optional) Enable Designate API Version 2.
#  Defaults to $::os_service_default
#
# [*enable_api_admin*]
#  (optional) Enable Designate Admin API.
#  Defaults to $::os_service_default
#
# [*api_base_uri*]
#  Set the base URI of the Designate API service.
#
# [*listen*]
#  (optional) API host:port pairs to listen on.
#  Defaults to $::os_service_default
#
# [*workers*]
#  (optional) Number of api worker processes to spawn.
#  Defaults to $::os_workers
#
# [*threads*]
#  (optional) Number of api greenthreads to spawn.
#  Defaults to $::os_service_default
#
# [*enable_host_header*]
#  (optional) Enable host request headers.
#  Defaults to $::os_service_default
#
# [*max_header_line*]
#  (optional) Maximum line size of message headers to be accepted.
#  Defaults to $::os_service_default
#
# [*default_limit_admin*]
#  (optional) Default per-page limit for the Admin API.
#  Defaults to $::os_service_default
#
# [*max_limit_admin*]
#  (optional) Max page size in the Admin API.
#  Defaults to $::os_service_default
#
# [*default_limit_v2*]
#  (optional) Default per-page limit for the V2 API.
#  Defaults to $::os_service_default
#
# [*max_limit_v2*]
#  (optional) Max page size in the V2 API.
#  Defaults to $::os_service_default
#
# [*pecan_debug*]
#  (optional) Show the pecan HTML based debug interface (v2 only).
#  Defaults to $::os_service_default
#
# [*enabled_extensions_v2*]
#  (optional) API Version 2 extensions.
#  Defaults to $::os_service_default
#
# [*enabled_extensions_admin*]
#  (optional) Admin API extensions.
#  Defaults to $::os_service_default
#
# [*enable_proxy_headers_parsing*]
#   (Optional) Enable paste middleware to handle SSL requests through
#   HTTPProxyToWSGI middleware.
#   Defaults to $::os_service_default.
#
# DEPRECATED PARAMETERS
#
# [*enabled_extensions_v1*]
#  (optional) API Version 1 extensions.
#  Defaults to undef
#
# [*service_ensure*]
#  (optional) Whether the designate api service will be running.
#  Defaults to 'DEPRECATED'
#
class designate::api (
  $package_ensure               = present,
  $api_package_name             = $::designate::params::api_package_name,
  $enabled                      = true,
  $manage_service               = true,
  $auth_strategy                = $::os_service_default,
  $enable_api_v2                = $::os_service_default,
  $enable_api_admin             = $::os_service_default,
  $api_base_uri                 = $::os_service_default,
  $listen                       = $::os_service_default,
  $workers                      = $::os_workers,
  $threads                      = $::os_service_default,
  $enable_host_header           = $::os_service_default,
  $max_header_line              = $::os_service_default,
  $default_limit_admin          = $::os_service_default,
  $max_limit_admin              = $::os_service_default,
  $default_limit_v2             = $::os_service_default,
  $max_limit_v2                 = $::os_service_default,
  $pecan_debug                  = $::os_service_default,
  $enabled_extensions_v2        = $::os_service_default,
  $enabled_extensions_admin     = $::os_service_default,
  $enable_proxy_headers_parsing = $::os_service_default,
  # DEPRECATED PARAMETERS
  $enabled_extensions_v1        = undef,
  $service_ensure               = 'DEPRECATED',
) inherits designate {

  include designate::deps

  if $enabled_extensions_v1 != undef {
    warning('The enabled_extensions_v1 parameter has been deprecated and has \
no effect now')
  }

  if $service_ensure != 'DEPRECATED' {
    warning('The service_ensure parameter is deprecated. Use the manage_service parameter.')
    $manage_service_real = $service_ensure
  } else {
    $manage_service_real = $manage_service
  }

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
    'service:api/max_header_line'           : value => $max_header_line;
    'service:api/default_limit_admin'       : value => $default_limit_admin;
    'service:api/max_limit_admin'           : value => $max_limit_admin;
    'service:api/default_limit_v2'          : value => $default_limit_v2;
    'service:api/max_limit_v2'              : value => $max_limit_v2;
    'service:api/pecan_debug'               : value => $pecan_debug;
    'service:api/enabled_extensions_v2'     : value => $enabled_extensions_v2;
    'service:api/enabled_extensions_admin'  : value => $enabled_extensions_admin;
  }

  if $auth_strategy == 'keystone' {
    include designate::keystone::authtoken
  }

  oslo::middleware { 'designate_config':
    enable_proxy_headers_parsing => $enable_proxy_headers_parsing
  }

  designate::generic_service { 'api':
    enabled        => $enabled,
    manage_service => $manage_service_real,
    package_ensure => $package_ensure,
    package_name   => $api_package_name,
    service_name   => $::designate::params::api_service_name,
  }
}
