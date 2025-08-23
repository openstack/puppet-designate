# == Class: designate::network_api::neutron
#
# Configure the [network_api:neutron] parameters
#
# === Parameters
#
# [*endpoints*]
#  (Optional) URL to use. Format: <retion>|<url>
#  Defaults to $facts['os_service_default'].
#
# [*endpoint_type*]
#  (Optional) Endpoint type to use
#  Defaults to $facts['os_service_default'].
#
# [*timeout*]
#  (Optional) Timeout value for connecting to neutron in seconds.
#  Defaults to $facts['os_service_default'].
#
class designate::network_api::neutron (
  $endpoints     = $facts['os_service_default'],
  $endpoint_type = $facts['os_service_default'],
  $timeout       = $facts['os_service_default'],
) {
  include designate::deps
  include designate::params

  designate_config {
    'network_api:neutron/endpoints':     value => join(any2array($endpoints), ',');
    'network_api:neutron/endpoint_type': value => $endpoint_type;
    'network_api:neutron/timeout':       value => $timeout;
  }
}
