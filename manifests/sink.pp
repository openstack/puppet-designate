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
#  Defaults to $::designate::params::sink_package_name
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
  $sink_package_name             = $::designate::params::sink_package_name,
  $enabled                       = true,
  $service_ensure                = 'running',
  $enabled_notification_handlers = undef,
) inherits designate {

  include ::designate::deps

  designate::generic_service { 'sink':
    enabled        => $enabled,
    manage_service => $service_ensure,
    package_ensure => $package_ensure,
    package_name   => $sink_package_name,
    service_name   => $::designate::params::sink_service_name,
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

}
