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
# [*service_ensure*]
#  (optional) Whether the designate api service will be running.
#  Defaults to 'running'
#
# [*auth_strategy*]
#  (optional) Authentication strategy to use, can be either "noauth" or
#  "keystone"
#  Defaults to 'noauth'
#
# [*enable_api_v1*]
#  (optional) Enable Designate API Version 1
#  Defaults to true
#
# [*enable_api_v2*]
#  (optional) Enable Designate API Version 2 (experimental)
#  Defaults to false
#
# [*enable_api_admin*]
#  (optional) Enable Designate Admin API
#  Defaults to false.
#
# [*api_host*]
#  (optional) Address to bind the API server
#  Defaults to '0.0.0.0'
#
# [*api_port*]
#  (optional) Port the bind the API server to
#  Defaults to '9001'
#
# [*api_base_uri*]
#  Set the base URI of the Designate API service.
#
# KeystoneMiddleware Parameters
#
# [*username*]
#  (optional) The name of the service user
#  Defaults to 'designate'
#
# [*password*]
#  (optional) Password for the user
#  Defaults to $::os_service_default
#
# [*auth_url*]
#  (optional) The URL to use for admin authentication.
#  Defaults to: 'http://localhost:35357'
#
# [*auth_uri*]
#  (optional) The URL to use for public authentication.
#  Defaults to: 'http://localhost:5000'.
#
# [*project_name*]
#  (optional) Service project name
#  Defaults to 'services'
#
# [*user_domain_name*]
#  (optional) Name of domain for $username
#  Defaults to $::os_service_default
#
# [*project_domain_name*]
#  (optional) Name of domain for $project_name
#  Defaults to $::os_service_default
#
# [*insecure*]
#  (optional) If true, explicitly allow TLS without checking server cert
#  against any certificate authorities.
#  WARNING: not recommended.  Use with caution.
#  Defaults to $::os_service_default
#
# [*auth_section*]
#  (optional) Config Section from which to load plugin specific options
#  Defaults to $::os_service_default
#
# [*auth_type*]
#  (optional) Authentication type to load
#  Defaults to $::os_service_default
#
# [*cache*]
#  (optional) Env key for the swift cache.
#  Defaults to $::os_service_default
#
# [*cafile*]
#  (optional) A PEM encoded Certificate Authority to use when verifying HTTPs
#  connections
#  Defaults to $::os_service_default
#
# [*certfile*]
#  (optional) Required if identity server requires client certificate
#  Defaults to $::os_service_default
#
# [*check_revocations_for_cached*]
#  (optional) If true, the revocation list will be checked for cached tokens.
#  This requires that PKI tokens are configured on the identity server.
#  boolean value.
#  Defaults to $::os_service_default
#
# [*delay_auth_decision*]
#  (optional) Do not handle authorization requests within the middleware, but
#  delegate the authorization decision to downstream WSGI components. Boolean
#  value
#  Defaults to $::os_service_default
#
# [*enforce_token_bind*]
#  (Optional) Used to control the use and type of token binding. Can be set
#  to: "disabled" to not check token binding. "permissive" (default) to
#  validate binding information if the bind type is of a form known to the
#  server and ignore it if not. "strict" like "permissive" but if the bind
#  type is unknown the token will be rejected. "required" any form of token
#  binding is needed to be allowed. Finally the name of a binding method that
#  must be present in tokens. String value.
#  Defaults to $::os_service_default.
#
# [*hash_algorithms*]
#  (Optional) Hash algorithms to use for hashing PKI tokens. This may be a
#  single algorithm or multiple. The algorithms are those supported by Python
#  standard hashlib.new(). The hashes will be tried in the order given, so put
#  the preferred one first for performance. The result of the first hash will
#  be stored in the cache. This will typically be set to multiple values only
#  while migrating from a less secure algorithm to a more secure one. Once all
#  the old tokens are expired this option should be set to a single value for
#  better performance. List value.
#  Defaults to $::os_service_default.
#
# [*http_connect_timeout*]
#  (optional) Request timeout value for communicating with Identity API server.
#  Defaults to $::os_service_default
#
# [*http_request_max_retries*]
#  (optional) How many times are we trying to reconnect when communicating
#  with Identity API Server. Integer value
#  Defaults to $::os_service_default
#
# [*include_service_catalog*]
#  (Optional) Indicate whether to set the X-Service-Catalog header. If False,
#  middleware will not ask for service catalog on token validation and will not
#  set the X-Service-Catalog header. Boolean value.
#  Defaults to $::os_service_default.
#
# [*keyfile*]
#  (Optional) Required if identity server requires client certificate
#  Defaults to $::os_service_default.
#
# [*memcache_pool_conn_get_timeout*]
#  (Optional) Number of seconds that an operation will wait to get a memcached
#  client connection from the pool. Integer value
#  Defaults to $::os_service_default.
#
# [*memcache_pool_dead_retry*]
#  (Optional) Number of seconds memcached server is considered dead before it
#  is tried again. Integer value
#  Defaults to $::os_service_default.
#
# [*memcache_pool_maxsize*]
#  (Optional) Maximum total number of open connections to every memcached
#  server. Integer value
#  Defaults to $::os_service_default.
#
# [*memcache_pool_socket_timeout*]
#  (Optional) Number of seconds a connection to memcached is held unused in
#  the
#  pool before it is closed. Integer value
#  Defaults to $::os_service_default.
#
# [*memcache_pool_unused_timeout*]
#  (Optional) Number of seconds a connection to memcached is held unused in
#  the
#  pool before it is closed. Integer value
#  Defaults to $::os_service_default.
#
# [*memcache_secret_key*]
#  (Optional, mandatory if memcache_security_strategy is defined) This string
#  is used for key derivation.
#  Defaults to $::os_service_default.
#
# [*memcache_security_strategy*]
#  (Optional) If defined, indicate whether token data should be authenticated
#  or
#  authenticated and encrypted. If MAC, token data is authenticated (with
#  HMAC)
#  in the cache. If ENCRYPT, token data is encrypted and authenticated in the
#  cache. If the value is not one of these options or empty, auth_token will
#  raise an exception on initialization.
#  Defaults to $::os_service_default.
#
# [*memcache_use_advanced_pool*]
#  (Optional)  Use the advanced (eventlet safe) memcached client pool. The
#  advanced pool will only work under python 2.x Boolean value
#  Defaults to $::os_service_default.
#
# [*memcached_servers*]
#  (Optional) Optionally specify a list of memcached server(s) to use for
#  caching. If left undefined, tokens will instead be cached in-process.
#  Defaults to $::os_service_default.
#
# [*region_name*]
#  (Optional) The region in which the identity server can be found.
#  Defaults to $::os_service_default.
#
# [*region_name*]
#  (optional)
#  Defaults to $::os_service_default
#
# [*revocation_cache_time*]
#  (Optional) Determines the frequency at which the list of revoked tokens is
#  retrieved from the Identity service (in seconds). A high number of
#  revocation events combined with a low cache duration may significantly
#  reduce performance. Only valid for PKI tokens. Integer value
#  Defaults to $::os_service_default.
#
# [*signing_dir*]
#  (Optional) Directory used to cache files related to PKI tokens.
#  Defaults to $::os_service_default.
#
# [*token_cache_time*]
#  (Optional) In order to prevent excessive effort spent validating tokens,
#  the middleware caches previously-seen tokens for a configurable duration
#  (in seconds). Set to -1 to disable caching completely. Integer value
#  Defaults to $::os_service_default.
#
# [*auth_version*]
#   (optional) API version of the identity API endpoint
#   Defaults to $::os_service_default.
#
# DEPRECATED PARAMETERS
#
# [*keystone_host*]
#  (optional) Host running auth service.
#  Defaults to undef
#
# [*keystone_port*]
#  (optional) Port to use for auth service on auth_host.
#  Defaults to undef
#
# [*keystone_protocol*]
#  (optional) Protocol to use for auth.
#  Defaults to undef
#
# [*keystone_tenant*]
#  (optional) Tenant to authenticate to.
#  Defaults to undef
#
# [*keystone_user*]
#  (optional) User to authenticate as with keystone.
#  Defaults to undef
#
# [*keystone_password*]
#  (optional) Password used to authentication.
#  Defaults to undef
#
# [*keystone_memcached_servers*]
#  (optional) Memcached Servers for keystone. Supply a list of memcached server
#  IP's:Memcached Port.
#  Defaults to false
#
class designate::api (
  $package_ensure                 = present,
  $api_package_name               = $::designate::params::api_package_name,
  $enabled                        = true,
  $service_ensure                 = 'running',
  $auth_strategy                  = 'noauth',
  $enable_api_v1                  = true,
  $enable_api_v2                  = false,
  $enable_api_admin               = false,
  $api_host                       = '0.0.0.0',
  $api_port                       = '9001',
  $api_base_uri                   = $::os_service_default,
  # keystone::resource::authtoken parameters
  $username                       = 'designate',
  $password                       = $::os_service_default,
  $auth_url                       = 'http://localhost:35357',
  $auth_uri                       = 'http://localhost:5000',
  $project_name                   = 'services',
  $user_domain_name               = $::os_service_default,
  $project_domain_name            = $::os_service_default,
  $insecure                       = $::os_service_default,
  $auth_section                   = $::os_service_default,
  $auth_type                      = 'password',
  $cache                          = $::os_service_default,
  $cafile                         = $::os_service_default,
  $certfile                       = $::os_service_default,
  $check_revocations_for_cached   = $::os_service_default,
  $delay_auth_decision            = $::os_service_default,
  $enforce_token_bind             = $::os_service_default,
  $hash_algorithms                = $::os_service_default,
  $http_connect_timeout           = $::os_service_default,
  $http_request_max_retries       = $::os_service_default,
  $include_service_catalog        = $::os_service_default,
  $keyfile                        = $::os_service_default,
  $memcache_pool_conn_get_timeout = $::os_service_default,
  $memcache_pool_dead_retry       = $::os_service_default,
  $memcache_pool_maxsize          = $::os_service_default,
  $memcache_pool_socket_timeout   = $::os_service_default,
  $memcache_secret_key            = $::os_service_default,
  $memcache_security_strategy     = $::os_service_default,
  $memcache_use_advanced_pool     = $::os_service_default,
  $memcache_pool_unused_timeout   = $::os_service_default,
  $memcached_servers              = $::os_service_default,
  $region_name                    = $::os_service_default,
  $revocation_cache_time          = $::os_service_default,
  $signing_dir                    = $::os_service_default,
  $token_cache_time               = $::os_service_default,
  $auth_version                   = $::os_service_default,
  # DEPRECATED PARAMETERS
  $keystone_host                  = undef,
  $keystone_port                  = undef,
  $keystone_protocol              = undef,
  $keystone_tenant                = undef,
  $keystone_user                  = undef,
  $keystone_password              = undef,
  $keystone_memcached_servers     = undef,
) inherits designate {

  # API Service
  designate_config {
    'service:api/api_host'                  : value => $api_host;
    'service:api/api_port'                  : value => $api_port;
    'service:api/auth_strategy'             : value => $auth_strategy;
    'service:api/enable_api_v1'             : value => $enable_api_v1;
    'service:api/enable_api_v2'             : value => $enable_api_v2;
    'service:api/enable_api_admin'          : value => $enable_api_admin;
    'service:api/api_base_uri'              : value => $api_base_uri;
  }

  # Keystone Middleware
  if ($keystone_host and $keystone_port and $keystone_protocol) {
    warning('keystone_host, keystone_port and keystone_protocol are deprecated, use auth_uri and auth_url instead')
    $auth_uri_real = "${keystone_protocol}://${keystone_host}:${keystone_port}"
    $auth_url_real = "${keystone_protocol}://${keystone_host}:${keystone_port}"
  } else {
    $auth_uri_real = $auth_uri
    $auth_url_real = $auth_url
  }

  if ($keystone_user) {
    warning('keystone_user is deprecated, use username instead')
    $username_real = $keystone_user
  } else {
    $username_real = $username
  }

  if ($keystone_password) {
    warning('keystone_password is deprecated, use password instead')
    $password_real = $keystone_password
  } else {
    $password_real = $password
  }

  if ($keystone_tenant) {
    warning('keystone_tenant is deprecated, use project_name instead')
    $project_name_real = $keystone_tenant
  } else {
    $project_name_real = $project_name
  }

  if ($keystone_memcached_servers) {
    warning('keystone_memcached_servers is deprecated use memcached_servers instead')
    $memcached_servers_real = $keystone_memcached_servers
  } else {
    $memcached_servers_real = $memcached_servers
  }

  keystone::resource::authtoken { 'designate_config':
    username                       => $username_real,
    password                       => $password_real,
    auth_url                       => $auth_url_real,
    project_name                   => $project_name_real,
    user_domain_name               => $user_domain_name,
    project_domain_name            => $project_domain_name,
    insecure                       => $insecure,
    auth_section                   => $auth_section,
    auth_type                      => $auth_type,
    auth_uri                       => $auth_uri_real,
    auth_version                   => $auth_version,
    cache                          => $cache,
    cafile                         => $cafile,
    certfile                       => $certfile,
    check_revocations_for_cached   => $check_revocations_for_cached,
    delay_auth_decision            => $delay_auth_decision,
    enforce_token_bind             => $enforce_token_bind,
    hash_algorithms                => $hash_algorithms,
    http_connect_timeout           => $http_connect_timeout,
    http_request_max_retries       => $http_request_max_retries,
    include_service_catalog        => $include_service_catalog,
    keyfile                        => $keyfile,
    memcache_pool_conn_get_timeout => $memcache_pool_conn_get_timeout,
    memcache_pool_dead_retry       => $memcache_pool_dead_retry,
    memcache_pool_maxsize          => $memcache_pool_maxsize,
    memcache_pool_socket_timeout   => $memcache_pool_socket_timeout,
    memcache_pool_unused_timeout   => $memcache_pool_unused_timeout,
    memcache_secret_key            => $memcache_secret_key,
    memcache_security_strategy     => $memcache_security_strategy,
    memcache_use_advanced_pool     => $memcache_use_advanced_pool,
    memcached_servers              => $memcached_servers_real,
    region_name                    => $region_name,
    revocation_cache_time          => $revocation_cache_time,
    signing_dir                    => $signing_dir,
    token_cache_time               => $token_cache_time,
  }

  designate::generic_service { 'api':
    enabled        => $enabled,
    manage_service => $service_ensure,
    ensure_package => $package_ensure,
    package_name   => $api_package_name,
    service_name   => $::designate::params::api_service_name,
  }

}
