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
#  Defaults to $designate::params::sink_package_name
#
# [*enabled*]
#  (optional) Whether to enable services.
#  Defaults to true
#
# [*manage_service*]
#   (Optional) Whether the designate sink service will be managed.
#   Defaults to true.
#
# [*workers*]
#  (optional) Number of sink worker processes to spawn.
#  Defaults to $facts['os_service_default']
#
# [*threads*]
#  (optional) Number of sink greenthreads to spawn.
#  Defaults to $facts['os_service_default']
#
# [*enabled_notification_handlers*]
#  (optional) List of notification handlers to enable, configuration of
#  these needs to correspond to a [handler:my_driver] section below or
#  else in the config.
#  Defaults to $facts['os_service_default']
#
class designate::sink (
  $package_ensure                = present,
  $sink_package_name             = $designate::params::sink_package_name,
  Boolean $enabled               = true,
  Boolean $manage_service        = true,
  $workers                       = $facts['os_service_default'],
  $threads                       = $facts['os_service_default'],
  $enabled_notification_handlers = $facts['os_service_default'],
) inherits designate::params {

  include designate::deps

  designate::generic_service { 'sink':
    enabled        => $enabled,
    manage_service => $manage_service,
    package_ensure => $package_ensure,
    package_name   => $sink_package_name,
    service_name   => $designate::params::sink_service_name,
  }

  designate_config {
    'service:sink/workers': value => $workers;
    'service:sink/threads': value => $threads;
  }

  designate_config {
    'service:sink/enabled_notification_handlers': value => join(any2array($enabled_notification_handlers), ','),
  }
}
