# == Class designate::producer_task::delayed_notify
#
# Configure delayed_notify producer task in designate-producer
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
class designate::producer_task::delayed_notify (
  $interval   = $facts['os_service_default'],
  $per_page   = $facts['os_service_default'],
  $batch_size = $facts['os_service_default'],
) {

  include designate::deps

  designate_config {
    'producer_task:delayed_notify/interval':   value => $interval;
    'producer_task:delayed_notify/per_page':   value => $per_page;
    'producer_task:delayed_notify/batch_size': value => $batch_size;
  }
}
