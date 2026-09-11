# == Class designate::producer_task::periodic_check_service_status
#
# Configure periodic_check_service_status producer task in designate-producer
#
# == Parameters
#
# [*interval*]
#  (optional) Run interval in seconds.
#  Defaults to $facts['os_service_default']
#
# [*per_page*]
#  (optional) Default amount of results returned per page.
#  Defaults to $facts['os_service_default']
#
# [*time_threshold*]
#  (optional) How old DOWN services should be deleted, in seconds.
#  Defaults to $facts['os_service_default']
#
class designate::producer_task::periodic_check_service_status (
  $interval       = $facts['os_service_default'],
  $per_page       = $facts['os_service_default'],
  $time_threshold = $facts['os_service_default'],
) {
  include designate::deps

  designate_config {
    'producer_task:periodic_check_service_status/interval':
      value => $interval;
    'producer_task:periodic_check_service_status/per_page':
      value => $per_page;
    'producer_task:periodic_check_service_status/time_threshold':
      value => $time_threshold;
  }
}
