# == Class designate::central
#
# Configure designate central service
#
# == Parameters
#
# [*package_ensure*]
#  (optional) The state of the package
#  Defaults to 'present'
#
# [*central_package_name*]
#  (optional) Name of the package containing central resources
#  Defaults to $designate::params::central_package_name
#
# [*enabled*]
#   (optional) Whether to enable services.
#   Defaults to true
#
# [*manage_service*]
#   (Optional) Whether the designate central service will be managed.
#   Defaults to true.
#
# [*managed_resource_email*]
#  (optional) Email to use for managed resources like domains created by the FloatingIP API
#  Defaults to 'hostmaster@example.com'
#
# [*managed_resource_tenant_id*]
#  (optional) Tenant ID to own all managed resources - like auto-created records etc.
#  Defaults to $facts['os_service_default']
#
# [*max_zone_name_len*]
#  (optional) Maximum zone name length.
#  Defaults to $facts['os_service_default']
#
# [*max_recordset_name_len*]
#  (optional) Maximum record name length.
#  Defaults to $facts['os_service_default']
#
# [*min_ttl*]
#  (optional) Minimum TTL.
#  Defaults to $facts['os_service_default']
#
# [*workers*]
#  (optional) Number of central worker processes to spawn.
#  Defaults to $facts['os_workers']
#
# [*threads*]
#  (optional) Number of central greenthreads to spawn.
#  Defaults to $facts['os_service_default']
#
# [*default_pool_id*]
#  (optional) The name of the default pool.
#  Defaults to $facts['os_service_default']
#
# [*scheduler_filters*]
#  (optional) Enabled pool scheduling filters.
#  Defaults to $facts['os_service_default']
#
class designate::central (
  $package_ensure             = present,
  $central_package_name       = $designate::params::central_package_name,
  Boolean $enabled            = true,
  Boolean $manage_service     = true,
  $managed_resource_email     = 'hostmaster@example.com',
  $managed_resource_tenant_id = $facts['os_service_default'],
  $max_zone_name_len          = $facts['os_service_default'],
  $max_recordset_name_len     = $facts['os_service_default'],
  $min_ttl                    = $facts['os_service_default'],
  $workers                    = $facts['os_workers'],
  $threads                    = $facts['os_service_default'],
  $default_pool_id            = $facts['os_service_default'],
  $scheduler_filters          = $facts['os_service_default'],
) inherits designate::params {

  include designate::deps
  include designate::db

  designate_config {
    'service:central/managed_resource_email'     : value => $managed_resource_email;
    'service:central/managed_resource_tenant_id' : value => $managed_resource_tenant_id;
    'service:central/max_zone_name_len'          : value => $max_zone_name_len;
    'service:central/max_recordset_name_len'     : value => $max_recordset_name_len;
    'service:central/min_ttl'                    : value => $min_ttl;
    'service:central/workers'                    : value => $workers;
    'service:central/threads'                    : value => $threads;
    'service:central/default_pool_id'            : value => $default_pool_id;
    'service:central/scheduler_filters'          : value => join(any2array($scheduler_filters), ',');
  }

  designate::generic_service { 'central':
    enabled        => $enabled,
    manage_service => $manage_service,
    package_ensure => $package_ensure,
    package_name   => $central_package_name,
    service_name   => $designate::params::central_service_name,
  }
}
