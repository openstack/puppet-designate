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
# [*service_name*]
#   (optional) Name of the service.
#   Defaults to the value of auth_name.
#
# [*service_type*]
#    Type of service. Optional. Defaults to 'metering'.
#
# [*public_address*]
#    Public address for endpoint. Optional. Defaults to '127.0.0.1'.
#
# [*admin_address*]
#    Admin address for endpoint. Optional. Defaults to '127.0.0.1'.
#
# [*internal_address*]
#    Internal address for endpoint. Optional. Defaults to '127.0.0.1'.
#
# [*port*]
#    Port for endpoint. Optional. Defaults to '8777'.
#
# [*region*]
#    Region for endpoint. Optional. Defaults to 'RegionOne'.
#
# [*tenant*]
#    Tenant for designate user. Optional. Defaults to 'services'.
#
# [*public_protocol*]
#    Protocol for public endpoint. Optional. Defaults to 'http'.
#
# [*admin_protocol*]
#    Protocol for admin endpoint. Optional. Defaults to 'http'.
#
# [*internal_protocol*]
#    Protocol for internal endpoint. Optional. Defaults to 'http'.
#
# [*version*]
#    API version endpoint.  Optional. Defaults to 'v1'.
#
class designate::keystone::auth (
  $password           = false,
  $email              = 'designate@localhost',
  $auth_name          = 'designate',
  $service_name       = undef,
  $service_type       = 'dns',
  $public_address     = '127.0.0.1',
  $admin_address      = '127.0.0.1',
  $internal_address   = '127.0.0.1',
  $port               = '9001',
  $region             = 'RegionOne',
  $tenant             = 'services',
  $public_protocol    = 'http',
  $admin_protocol     = 'http',
  $internal_protocol  = 'http',
  $version            = 'v1',
  $configure_endpoint = true
) {

  $real_service_name = pick($service_name, $auth_name)

  Keystone_user_role["${auth_name}@${tenant}"] ~>
    Service <| name == 'designate-api' |>

  keystone::resource::service_identity { 'designate':
    configure_user      => true,
    configure_user_role => true,
    configure_endpoint  => $configure_endpoint,
    service_name        => $real_service_name,
    service_type        => $service_type,
    service_description => 'Openstack DNSaas Service',
    region              => $region,
    auth_name           => $auth_name,
    password            => $password,
    email               => $email,
    tenant              => $tenant,
    public_url          => "${public_protocol}://${public_address}:${port}/${version}",
    internal_url        => "${internal_protocol}://${internal_address}:${port}/${version}",
    admin_url           => "${admin_protocol}://${admin_address}:${port}/${version}",
  }

}
