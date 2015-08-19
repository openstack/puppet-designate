# == Class designate::sink
#
# Configure designate sink service
#
# == Parameters
#
# [*package_ensure*]
#  (optional) The state of the package
#  Defaults to 'present'
#
# [*sink_package_name*]
#  (optional) Name of the package containing sink resources
#  Defaults to sink_package_name from designate::params
#
# [*enabled*]
#  (optional) Whether to enable services.
#  Defaults to true
#
# [*service_ensure*]
#  (optional) Whether the designate sink service will be running.
#  Defaults to 'running'
#
# [*enabled_notification_handlers*]
#  (optional) List of notification handlers to enable, configuration of
#  these needs to correspond to a [handler:my_driver] section below or
#  else in the config.
#  Defaults to undef
#
class designate::sink (
  $package_ensure                = present,
  $sink_package_name             = undef,
  $enabled                       = true,
  $service_ensure                = 'running',
  $enabled_notification_handlers = undef,
) {
  include ::designate::params

  package { 'designate-sink':
    ensure => $package_ensure,
    name   => pick($sink_package_name, $::designate::params::sink_service_name),
    tag    => ['openstack', 'designate-package'],
  }

  if $enabled_notification_handlers {
    designate_config {
      'service:sink/enabled_notification_handlers':  value => join($enabled_notification_handlers,',')
    }
  } else {
    designate_config {
      'service:sink/enabled_notification_handlers':  ensure => absent
    }
  }

  service { 'designate-sink':
    ensure     => $service_ensure,
    name       => $::designate::params::sink_service_name,
    enable     => $enabled,
    hasstatus  => true,
    hasrestart => true,
    tag        => ['openstack', 'designate-service'],
  }
}
