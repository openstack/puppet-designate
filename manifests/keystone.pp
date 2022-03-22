# == Class: designate::keystone
#
# Configures [keystone] parameters of designate.conf
#
# === Parameters:
#
# [*timeout*]
#   (Optional) Timeout value for connecting to keystone in seconds.
#   Defaults to $::os_service_default
#
# [*service_type*]
#   (Optional) The default service_type for endpoint URL discovery.
#   Defaults to $::os_service_default
#
# [*valid_interfaces*]
#   (Optional) List of interfaces, in order of preference for endpoint URL.
#   Defaults to $::os_service_default
#
# [*endpoint_override*]
#   (Optional) Always use this endpoint URL for requests for this client.
#   Defaults to $::os_service_default
#
# [*region_name*]
#   (Optional) Region name for connecting to keystone in admin context
#   through the OpenStack Identity service.
#   Defaults to $::os_service_default
#
# [*connect_retries*]
#   (Optional) The maximum number o retries that should be attempted for
#   connection errors.
#   Defaults to $::os_service_default
#
# [*connect_retry_delay*]
#   (Optional) Delay (in seconds) between two retries that should be attempted
#   for connection errors.
#   Defaults to $::os_service_default
#
# [*status_code_retries*]
#   (Optional) The maximum number of retries that should be attempted for
#   retriable HTTP status codes.
#   Defaults to $::os_service_default
#
# [*status_code_retry_delay*]
#   (Optional) Delay (in seconds) between two retries for retriable status
#   codes.
#   Defaults to $::os_service_default
#
class designate::keystone (
  $timeout                 = $::os_service_default,
  $service_type            = $::os_service_default,
  $valid_interfaces        = $::os_service_default,
  $endpoint_override       = $::os_service_default,
  $region_name             = $::os_service_default,
  $connect_retries         = $::os_service_default,
  $connect_retry_delay     = $::os_service_default,
  $status_code_retries     = $::os_service_default,
  $status_code_retry_delay = $::os_service_default,
) {

  include designate::deps

  designate_config {
    'keystone/timeout':                 value => $timeout;
    'keystone/service_type':            value => $service_type;
    'keystone/valid_interfaces':        value => join(any2array($valid_interfaces), ',');
    'keystone/endpoint_override':       value => $endpoint_override;
    'keystone/region_name':             value => $region_name;
    'keystone/connect_retries':         value => $connect_retries;
    'keystone/connect_retry_delay':     value => $connect_retry_delay;
    'keystone/status_code_retries':     value => $status_code_retries;
    'keystone/status_code_retry_delay': value => $status_code_retry_delay;
  }
}
