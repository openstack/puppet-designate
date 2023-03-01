# == Class designate::agent::bind9
#
# DEPRECATED !!
# Configure bind9 as agent backend
#
# == Parameters
#
# [*rndc_host*]
#  (Optional) RNDC Host
#  Defaults to $facts['os_service_default'].
#
# [*rndc_port*]
#  (Optional) RNDC Port.
#  Defaults to 953.
#
# [*rndc_config_file*]
#  (Optional) Location of the rndc configuration file.
#  Defaults to '/etc/rndc.conf'
#
# [*rndc_key_file*]
#  (Optional) Location of the rndc key file.
#  Defaults to '/etc/rndc.key'
#
# [*rndc_timeout*]
#  (Optional) RNDC command timeout.
#  Defaults to $facts['os_service_default'].
#
# [*zone_file_path*]
#  (Optional) Path where zone files are stored.
#  Defaults to $facts['os_service_default'].
#
# [*query_destination*]
#  (Optional) Host to query when finding zones.
#  Defaults to $facts['os_service_default'].
#
class designate::agent::bind9 (
  $rndc_host         = $facts['os_service_default'],
  $rndc_port         = $facts['os_service_default'],
  $rndc_config_file  = '/etc/rndc.conf',
  $rndc_key_file     = '/etc/rndc.key',
  $rndc_timeout      = $facts['os_service_default'],
  $zone_file_path    = $facts['os_service_default'],
  $query_destination = $facts['os_service_default'],
) {

  include designate::deps

  warning('The agent framework has been deprecated.')

  designate_config {
    'backend:agent:bind9/rndc_host'         : value => $rndc_host;
    'backend:agent:bind9/rndc_port'         : value => $rndc_port;
    'backend:agent:bind9/rndc_config_file'  : value => $rndc_config_file;
    'backend:agent:bind9/rndc_key_file'     : value => $rndc_key_file;
    'backend:agent:bind9/rndc_timeout'      : value => $rndc_timeout;
    'backend:agent:bind9/zone_file_path'    : value => $zone_file_path;
    'backend:agent:bind9/query_destination' : value => $query_destination;
  }
}
