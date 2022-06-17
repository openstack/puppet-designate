# == Class: designate::network_api::neutron
#
# Configure the [network_api:neutron] parameters
#
# === Parameters
#
# [*endpoints*]
#  (Optional) URL to use. Format: <retion>|<url>
#  Defaults to $::os_service_default.
#
# [*endpoint_type*]
#  (Optional) Endpoint type to use
#  Defaults to $::os_service_default.
#
# [*timeout*]
#  (Optional) Timeout value for connecting to neutron in seconds.
#  Defaults to $::os_service_default.
#
class designate::network_api::neutron (
  $endpoints     = $::os_service_default,
  $endpoint_type = $::os_service_default,
  $timeout       = $::os_service_default,
) {
  include designate::deps
  include designate::params

  $endpoint_type_real = pick($::designate::neutron_endpoint_type, $endpoint_type)

  designate_config {
    'network_api:neutron/endpoints':     value => join(any2array($endpoints), ',');
    'network_api:neutron/endpoint_type': value => $endpoint_type_real;
    'network_api:neutron/timeout':       value => $timeout;
  }

}
