# == Class: designate::keystone::auth
#
# Configures designate user, service and endpoint in Keystone.
#
# === Parameters
#
# [*password*]
#   (Required) Password for designate user.
#
# [*email*]
#   (Optional) Email for designate user.
#   Defaults to 'designate@localhost'.
#
# [*auth_name*]
#   (Optional) Username for designate service.
#   Defaults to 'designate'.
#
# [*configure_endpoint*]
#   (Optional) Should designate endpoint be configured?
#   Defaults to true
#
# [*configure_user*]
#   (Optional) Should designate user be configured?
#   Defaults to true
#
# [*configure_user_role*]
#   (Optional) Should designate user_role be configured?
#   Defaults to true
#
# [*service_name*]
#   (Optional) Name of the service.
#   Defaults to 'designate'.
#
# [*service_type*]
#   (Optional) Type of service.
#   Defaults to 'metering'.
#
# [*service_description*]
#   (Optional) Description for keystone service.
#   Defaults to 'OpenStack DNSaas Service'.
#
# [*region*]
#   (Optional) Region for endpoint.
#   Defaults to 'RegionOne'.
#
# [*tenant*]
#   (Optional) Tenant for designate user.
#   Defaults to 'services'.
#
# [*roles*]
#   (Optional) List of roles assigned to designate user.
#   Defaults to ['admin']
#
# [*system_scope*]
#   (Optional) Scope for system operations.
#   Defaults to 'all'
#
# [*system_roles*]
#   (Optional) List of system roles assigned to designate user.
#   Defaults to []
#
# [*public_url*]
#   (0ptional) The endpoint's public url.
#   This url should *not* contain any trailing '/'.
#   Defaults to 'http://127.0.0.1:9001'
#
# [*admin_url*]
#   (Optional) The endpoint's admin url.
#   This url should *not* contain any trailing '/'.
#   Defaults to 'http://127.0.0.1:9001'
#
# [*internal_url*]
#   (Optional) The endpoint's internal url.
#   This url should *not* contain any trailing '/'.
#   Defaults to 'http://127.0.0.1:9001'
#
# === Examples
#
#  class { 'designate::keystone::auth':
#    public_url   => 'https://10.0.0.10:9001',
#    internal_url => 'https://10.0.0.11:9001',
#    admin_url    => 'https://10.0.0.11:9001',
#  }
#
class designate::keystone::auth (
  $password            = false,
  $email               = 'designate@localhost',
  $auth_name           = 'designate',
  $service_name        = 'designate',
  $service_type        = 'dns',
  $service_description = 'OpenStack DNSaas Service',
  $region              = 'RegionOne',
  $tenant              = 'services',
  $roles               = ['admin'],
  $system_scope        = 'all',
  $system_roles        = [],
  $configure_user      = true,
  $configure_user_role = true,
  $configure_endpoint  = true,
  $public_url          = 'http://127.0.0.1:9001',
  $admin_url           = 'http://127.0.0.1:9001',
  $internal_url        = 'http://127.0.0.1:9001',
) {

  include designate::deps

  Keystone::Resource::Service_identity['designate'] -> Anchor['designate::service::end']

  keystone::resource::service_identity { 'designate':
    configure_user      => $configure_user,
    configure_user_role => $configure_user_role,
    configure_endpoint  => $configure_endpoint,
    service_name        => $service_name,
    service_type        => $service_type,
    service_description => $service_description,
    region              => $region,
    auth_name           => $auth_name,
    password            => $password,
    email               => $email,
    tenant              => $tenant,
    roles               => $roles,
    system_scope        => $system_scope,
    system_roles        => $system_roles,
    public_url          => $public_url,
    internal_url        => $internal_url,
    admin_url           => $admin_url,
  }

}
