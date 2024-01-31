# == Class designate::sink::nova_fixed
#
# Configure nova notification handler options for designate sink service
#
# == Parameters
#
# [*notification_topics*]
#  (Optional) Notification any events from nova.
#  Defaults to $facts['os_service_default'].
#
# [*control_exchange*]
#  (Optional) control-exchange for nova notifications
#  Defaults to $facts['os_service_default'].
#
# [*zone_id*]
#  (Optional) Zone ID with each notification
#  Defaults to $facts['os_service_default'].
#
# [*formatv4*]
#  (Optional) IPv4 format.
#  Defaults to $facts['os_service_default'].
#
# [*formatv6*]
#  (Optional) IPv6 format.
#  Defaults to $facts['os_service_default'].
#
class designate::sink::nova_fixed (
  $notification_topics = $facts['os_service_default'],
  $control_exchange    = $facts['os_service_default'],
  $zone_id             = $facts['os_service_default'],
  $formatv4            = $facts['os_service_default'],
  $formatv6            = $facts['os_service_default'],
) {

  include designate::deps

  designate_config {
    'handler:nova_fixed/notification_topics': value => join(any2array($notification_topics), ',');
    'handler:nova_fixed/control_exchange':    value => $control_exchange;
    'handler:nova_fixed/zone_id':             value => $zone_id;
    'handler:nova_fixed/formatv4':            value => $formatv4;
    'handler:nova_fixed/formatv6':            value => $formatv6;
  }
}
