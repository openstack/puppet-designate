# == Class designate::producer_task::periodic_exists
#
# Configure periodic_exists producer task in designate-producer
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
class designate::producer_task::periodic_exists (
  $interval = $::os_service_default,
  $per_page = $::os_service_default,
) {

  include designate::deps

  designate_config {
    'producer_task:periodic_exists/interval': value => $interval;
    'producer_task:periodic_exists/per_page': value => $per_page;
  }
}
