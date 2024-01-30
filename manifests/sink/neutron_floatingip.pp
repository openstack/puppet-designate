# == Class designate::sink::neutron_floatingip
#
# Configure neutron notification handler options for designate sink service
#
# == Parameters
#
# [*notification_topics*]
#  (Optional) Notification any events from neutron.
#  Defaults to $facts['os_service_default'].
#
# [*control_exchange*]
#  (Optional) control-exchange for neutron notifications
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
class designate::sink::neutron_floatingip (
  $notification_topics = $facts['os_service_default'],
  $control_exchange    = $facts['os_service_default'],
  $zone_id             = $facts['os_service_default'],
  $formatv4            = $facts['os_service_default'],
  $formatv6            = $facts['os_service_default'],
) {

  include designate::deps

  designate_config {
    'handler:neutron_floatingip/notification_topics': value => join(any2array($notification_topics), ',');
    'handler:neutron_floatingip/control_exchange':    value => $control_exchange;
    'handler:neutron_floatingip/zone_id':             value => $zone_id;
    'handler:neutron_floatingip/formatv4':            value => $formatv4;
    'handler:neutron_floatingip/formatv6':            value => $formatv6;
  }
}
