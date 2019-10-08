# == Class: designate::pool_manager_cache::memcache
#
# DEPRECATED!
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

  warning('designate::pool_manager_cache::memcache is deprecated, \
has no effect and will be removed in the next release')
}
