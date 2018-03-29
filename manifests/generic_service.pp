#
# == Define: designate::generic_service
#
# This defined type implements basic designate services.
# It is introduced to attempt to consolidate
# common code.
#
# It also allows users to specify ad-hoc services
# as needed
#
# This define creates a service resource with title designate-${name} and
# conditionally creates a package resource with title designate-${name}
#
# === Parameters:
#
# [*package_name*]
#   (mandatory) The package name (for the generic_service)
#
# [*service_name*]
#   (mandatory) The service name (for the generic_service)
#
# [*enabled*]
#   (optional) Define if the service must be enabled or not
#   Defaults to false.
#
# [*manage_service*]
#   (optional) Manage or not the service (if a service_name is provided).
#   Defaults to true.
#
# [*package_ensure*]
#   (optional) Control the ensure parameter for the package ressource.
#   Defaults to 'present'.
#
define designate::generic_service(
  $package_name,
  $service_name,
  $enabled        = false,
  $manage_service = true,
  $package_ensure = 'present',
) {

  include ::designate::deps
  include ::designate::params
  include ::designate::db

  $designate_title = "designate-${name}"
  Exec['post-designate_config'] ~> Anchor['designate::service::end']

  if ($package_name) {
    if !defined(Package[$package_name]) {
      package { $designate_title:
        ensure => $package_ensure,
        name   => $package_name,
        notify => Anchor['designate::install::end'],
        tag    => ['openstack', 'designate-package'],
      }
    }
  }

  if $service_name {
    if $manage_service {
      if $enabled {
        $service_ensure = 'running'
      } else {
        $service_ensure = 'stopped'
      }
    }

    service { $designate_title:
      ensure    => $service_ensure,
      name      => $service_name,
      enable    => $enabled,
      hasstatus => true,
      tag       => ['openstack','designate-service'],
    }
  }
}
