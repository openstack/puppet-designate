# == Class designate::producer_task::increment_serial
#
# Configure increment_serial producer task in designate-producer
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
# [*batch_size*]
#  (optional) How many zones to receive NOTIFY on each run.
#  Defaults to $facts['os_service_default']
#
class designate::producer_task::increment_serial (
  $interval   = $facts['os_service_default'],
  $per_page   = $facts['os_service_default'],
  $batch_size = $facts['os_service_default'],
) {

  include designate::deps

  designate_config {
    'producer_task:increment_serial/interval':   value => $interval;
    'producer_task:increment_serial/per_page':   value => $per_page;
    'producer_task:increment_serial/batch_size': value => $batch_size;
  }
}
