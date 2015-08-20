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
#  Defaults to central_package_name from designate::params
#
# [*enabled*]
#   (optional) Whether to enable services.
#   Defaults to true
#
# [*service_ensure*]
#  (optional) Whether the designate central service will be running.
#  Defaults to 'running'
#
# [*backend_driver*]
#  (optional) Driver used for backend communication (fake, rpc, bind9, powerdns)
#  Defaults to 'bind9'
#
# [*managed_resource_email*]
#  (optional) Email to use for managed resources like domains created by the FloatingIP API
#  Defaults to 'hostmaster@example.com'
#
# [*managed_resource_tenant_id*]
#  (optional) Tenant ID to own all managed resources - like auto-created records etc.
#  Defaults to '123456'
#
class designate::central (
  $package_ensure             = present,
  $central_package_name       = undef,
  $enabled                    = true,
  $service_ensure             = 'running',
  $backend_driver             = 'bind9',
  $managed_resource_email     = 'hostmaster@example.com',
  $managed_resource_tenant_id = '123456',
) inherits designate {
  include ::designate::params

  designate_config {
    'service:central/backend_driver'             : value => $backend_driver;
    'service:central/managed_resource_email'     : value => $managed_resource_email;
    'service:central/managed_resource_tenant_id' : value => $managed_resource_tenant_id;
  }

  designate::generic_service { 'central':
    enabled        => $enabled,
    manage_service => $service_ensure,
    ensure_package => $package_ensure,
    package_name   => pick($central_package_name, $::designate::params::central_package_name),
    service_name   => $::designate::params::central_service_name,
  }
}
