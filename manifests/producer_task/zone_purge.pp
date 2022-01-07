# == Class designate::producer_task::zone_purge
#
# Configure zone_purge producer task in designate-producer
#
# == Parameters
#
# [*interval*]
#  (optional) Run interval in seconds.
#  Defaults to $::os_service_default
#
# [*per_page*]
#  (optional) Default amount of results returned per page.
#  Defaults to $::os_service_default
#
# [*time_threshold*]
#  (optional) How old deleted zones should be (deleted_at) to be purged, in
#  seconds.
#  Defaults to $::os_service_default
#
# [*batch_size*]
#  (optional) How many zones to receive NOTIFY on each run.
#  Defaults to $::os_service_default
#
class designate::producer_task::zone_purge (
  $interval       = $::os_service_default,
  $per_page       = $::os_service_default,
  $time_threshold = $::os_service_default,
  $batch_size     = $::os_service_default,
) {

  include designate::deps

  designate_config {
    'producer_task:zone_purge/interval':       value => $interval;
    'producer_task:zone_purge/per_page':       value => $per_page;
    'producer_task:zone_purge/time_threshold': value => $time_threshold;
    'producer_task:zone_purge/batch_size':     value => $batch_size;
  }
}
