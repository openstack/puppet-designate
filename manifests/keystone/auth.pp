# == Class: designate::keystone::auth
#
# Configures designate user, service and endpoint in Keystone.
#
# === Parameters
#
# [*password*]
#   Password for designate user. Required.
#
# [*email*]
#   Email for designate user. Optional. Defaults to 'designate@localhost'.
#
# [*auth_name*]
#   Username for designate service. Optional. Defaults to 'designate'.
#
# [*configure_endpoint*]
#   Should designate endpoint be configured? Optional. Defaults to 'true'.
#
# [*configure_user*]
#   Should designate user be configured?
#   Defaults to 'true'.
#
# [*configure_user_role*]
#   Should designate user_role be configured?
#   Defaults to 'true'.
#
# [*service_name*]
#   (optional) Name of the service.
#   Defaults to 'designate'.
#
# [*service_type*]
#    Type of service. Optional. Defaults to 'metering'.
#
# [*service_description*]
#    Description for keystone service. Optional. Defaults to 'Openstack DNSaas Service'.
#
# [*region*]
#    Region for endpoint. Optional. Defaults to 'RegionOne'.
#
# [*tenant*]
#    Tenant for designate user. Optional. Defaults to 'services'.
#
# [*public_url*]
#   (optional) The endpoint's public url. (Defaults to 'http://127.0.0.1:9001')
#   This url should *not* contain any trailing '/'.
#
# [*admin_url*]
#   (optional) The endpoint's admin url. (Defaults to 'http://127.0.0.1:9001')
#   This url should *not* contain any trailing '/'.
#
# [*internal_url*]
#   (optional) The endpoint's internal url. (Defaults to 'http://127.0.0.1:9001')
#   This url should *not* contain any trailing '/'.
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
  $service_description = 'Openstack DNSaas Service',
  $region              = 'RegionOne',
  $tenant              = 'services',
  $configure_user      = true,
  $configure_user_role = true,
  $configure_endpoint  = true,
  $public_url          = 'http://127.0.0.1:9001/v1',
  $admin_url           = 'http://127.0.0.1:9001/v1',
  $internal_url        = 'http://127.0.0.1:9001/v1',
) {

  include ::designate::deps

  if $configure_user_role {
    Keystone_user_role["${auth_name}@${tenant}"] ~> Anchor['designate::service::end']
  }

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
    public_url          => $public_url,
    internal_url        => $internal_url,
    admin_url           => $admin_url,
  }

}
