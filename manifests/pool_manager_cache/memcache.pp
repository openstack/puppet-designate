# == Class: designate::pool_manager_cache::memcache
#
# Configure Memcache as caching service for the pool manager.
#
# == Parameters
#
# [*memcached_servers*]
#  (optional) Memcache servers.
#  Defaults to ['127.0.0.1']
#
# [*expiration*]
#   Cache expiration time.
#   Defaults to $::os_service_default
#
class designate::pool_manager_cache::memcache(
  $memcached_servers = ['127.0.0.1'],
  $expiration        = $::os_service_default,
){

  include ::designate::deps

  validate_array($memcached_servers)

  designate_config {
    'service:pool_manager/cache_driver':             value => 'memcache';
    'pool_manager_cache:memcache/memcached_servers': value => join($memcached_servers,',');
    'pool_manager_cache:memcache/expiration':        value => $expiration;
  }
}
