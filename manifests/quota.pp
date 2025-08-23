# == Class designate::quota
#
# Configure designate quotas
#
# == Parameters
#
# [*quota_api_export_size*]
#   (optional) size of api export
#   Defaults to $facts['os_service_default']
#
# [*quota_zone_records*]
#   (optional) records per zone
#   Defaults to $facts['os_service_default']
#
# [*quota_zone_recordsets*]
#   (optional) recordsets per zone
#   Defaults to $facts['os_service_default']
#
# [*quota_zones*]
#   (optional) zones per project
#   Defaults to $facts['os_service_default']
#
# [*quota_driver*]
#   (optional) storage driver to use
#   Defaults to $facts['os_service_default']
#
# [*quota_recordset_records*]
#   (optional) recordsets per record
#   Defaults to $facts['os_service_default']
#
class designate::quota (
  $quota_api_export_size   = $facts['os_service_default'],
  $quota_zone_records      = $facts['os_service_default'],
  $quota_zone_recordsets   = $facts['os_service_default'],
  $quota_zones             = $facts['os_service_default'],
  $quota_driver            = $facts['os_service_default'],
  $quota_recordset_records = $facts['os_service_default'],
) {
  include designate::deps

  designate_config {
    'DEFAULT/quota_api_export_size':   value => $quota_api_export_size;
    'DEFAULT/quota_zone_records':      value => $quota_zone_records;
    'DEFAULT/quota_zone_recordsets':   value => $quota_zone_recordsets;
    'DEFAULT/quota_zones':             value => $quota_zones;
    'DEFAULT/quota_driver':            value => $quota_driver;
    'DEFAULT/quota_recordset_records': value => $quota_recordset_records;
  }
}
