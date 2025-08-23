# == Class designate::producer_task::periodic_secondary_refresh
#
# Configure periodic_secondary_refresh producer task in designate-producer
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
class designate::producer_task::periodic_secondary_refresh (
  $interval = $facts['os_service_default'],
  $per_page = $facts['os_service_default'],
) {
  include designate::deps

  designate_config {
    'producer_task:periodic_secondary_refresh/interval': value => $interval;
    'producer_task:periodic_secondary_refresh/per_page': value => $per_page;
  }
}
