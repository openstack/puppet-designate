# == Class designate
#
# Configure designate service
#
# == Parameters
#
# [*package_ensure*]
#  (optional) The state of the package
#  Defaults to 'present'
#
# [*common_package_name*]
#  (optional) Name of the package containing shared resources
#  Defaults to $::designate::params::common_package_name
#
# [*service_ensure*]
#  (optional) Whether the designate-common package will be present..
#  Defaults to 'present'
#
# [*debug*]
#   (optional) should the daemons log debug messages.
#   Defaults to undef
#
# [*use_syslog*]
#   (Optional) Use syslog for logging.
#   Defaults to undef
#
# [*use_stderr*]
#   (optional) Use stderr for logging
#   Defaults to undef
#
# [*log_facility*]
#   (Optional) Syslog facility to receive log lines.
#   Defaults to undef
#
# [*log_dir*]
#   (optional) Directory where logs should be stored.
#   If set to $::os_service_default, it will not log to any directory.
#   Defaults to undef
#
# [*root_helper*]
#   (optional) Command for designate rootwrap helper.
#   Defaults to 'sudo designate-rootwrap /etc/designate/rootwrap.conf'.
#
# [*default_transport_url*]
#   (optional) A URL representing the messaging driver to use and its full
#   configuration. Transport URLs take the form:
#     transport://user:pass@host1:port[,hostN:portN]/virtual_host
#   Defaults to $::os_service_default
#
# [*rpc_response_timeout*]
#  (Optional) Seconds to wait for a response from a call.
#  Defaults to $::os_service_default
#
# [*control_exchange*]
#   (Optional) The default exchange under which topics are scoped. May be
#   overridden by an exchange name specified in the transport_url
#   option.
#   Defaults to $::os_service_default
#
# [*notification_transport_url*]
#   (optional) Connection url for oslo messaging notification backend. An
#   example rabbit url would be, rabbit://user:pass@host:port/virtual_host
#   Defaults to $::os_service_default
#
# [*rabbit_use_ssl*]
#   (optional) Connect over SSL for RabbitMQ
#   Defaults to false
#
# [*rabbit_ha_queues*]
#   (optional) Use HA queues in RabbitMQ (x-ha-policy: all). If you change this
#   option, you must wipe the RabbitMQ database. (boolean value). Currently,
#   this value is set to true when rabbit_hosts is configured. This will change
#   during the Pike cycle where we will no longer do this check.
#
# [*kombu_ssl_ca_certs*]
#   (optional) SSL certification authority file (valid only if SSL enabled).
#   Defaults to $::os_service_default
#
# [*kombu_ssl_certfile*]
#   (optional) SSL cert file (valid only if SSL enabled).
#   Defaults to $::os_service_default
#
# [*kombu_ssl_keyfile*]
#   (optional) SSL key file (valid only if SSL enabled).
#   Defaults to $::os_service_default
#
# [*kombu_ssl_version*]
#   (optional) SSL version to use (valid only if SSL enabled).
#   Valid values are TLSv1, SSLv23 and SSLv3. SSLv2 may be
#   available on some distributions.
#   Defaults to $::os_service_default
#
# [*kombu_reconnect_delay*]
#   (optional) How long to wait before reconnecting in response to an AMQP
#   consumer cancel notification.
#   Defaults to $::os_service_default
#
# [*kombu_failover_strategy*]
#   (Optional) Determines how the next RabbitMQ node is chosen in case the one
#   we are currently connected to becomes unavailable. Takes effect only if
#   more than one RabbitMQ node is provided in config. (string value)
#   Defaults to $::os_service_default
#
# [*notification_driver*]
#   (optional) Driver used for issuing notifications
#   Defaults to 'messaging'
#
# [*notification_topics*]
#   (optional) Notification Topics
#   Defaults to 'notifications'
#
# [*purge_config*]
#   (optional) Whether to set only the specified config options
#   in the designate config.
#   Defaults to false
#
# [*amqp_durable_queues*]
#   (optional) Whether to use durable queues in AMQP.
#   Defaults to $::os_service_default.
#
# [*neutron_endpoint_type*]
#   (optional) Endpoint type to use.
#   Defaults to $::os_service_default.
#
class designate(
  $package_ensure             = present,
  $common_package_name        = $::designate::params::common_package_name,
  $debug                      = undef,
  $log_dir                    = undef,
  $use_syslog                 = undef,
  $use_stderr                 = undef,
  $log_facility               = undef,
  $root_helper                = 'sudo designate-rootwrap /etc/designate/rootwrap.conf',
  $notification_transport_url = $::os_service_default,
  $rabbit_use_ssl             = false,
  $rabbit_ha_queues           = $::os_service_default,
  $kombu_ssl_ca_certs         = $::os_service_default,
  $kombu_ssl_certfile         = $::os_service_default,
  $kombu_ssl_keyfile          = $::os_service_default,
  $kombu_ssl_version          = $::os_service_default,
  $kombu_reconnect_delay      = $::os_service_default,
  $kombu_failover_strategy    = $::os_service_default,
  $notification_driver        = 'messaging',
  $default_transport_url      = $::os_service_default,
  $rpc_response_timeout       = $::os_service_default,
  $control_exchange           = $::os_service_default,
  $notification_topics        = 'notifications',
  $purge_config               = false,
  $amqp_durable_queues        = $::os_service_default,
  $neutron_endpoint_type      = $::os_service_default,
) inherits designate::params {

  if !is_service_default($kombu_ssl_ca_certs) and !$rabbit_use_ssl {
    fail('The kombu_ssl_ca_certs parameter requires rabbit_use_ssl to be set to true')
  }
  if !is_service_default($kombu_ssl_certfile) and !$rabbit_use_ssl {
    fail('The kombu_ssl_certfile parameter requires rabbit_use_ssl to be set to true')
  }
  if !is_service_default($kombu_ssl_keyfile) and !$rabbit_use_ssl {
    fail('The kombu_ssl_keyfile parameter requires rabbit_use_ssl to be set to true')
  }
  if (is_service_default($kombu_ssl_certfile) and ! is_service_default($kombu_ssl_keyfile))
      or (is_service_default($kombu_ssl_keyfile) and ! is_service_default($kombu_ssl_certfile)) {
    fail('The kombu_ssl_certfile and kombu_ssl_keyfile parameters must be used together')
  }

  include ::designate::deps
  include ::designate::logging

  exec { 'post-designate_config':
    command     => '/bin/echo "designate config has changed"',
    refreshonly => true,
  }

  Anchor['designate::config::end'] ~> Exec['post-designate_config']

  package { 'designate-common':
    ensure => $package_ensure,
    name   => $common_package_name,
    tag    => ['openstack', 'designate-package'],
  }

  resources { 'designate_config':
    purge => $purge_config,
  }

  oslo::messaging::rabbit { 'designate_config':
    kombu_ssl_version       => $kombu_ssl_version,
    kombu_ssl_keyfile       => $kombu_ssl_keyfile,
    kombu_ssl_certfile      => $kombu_ssl_certfile,
    kombu_ssl_ca_certs      => $kombu_ssl_ca_certs,
    kombu_reconnect_delay   => $kombu_reconnect_delay,
    kombu_failover_strategy => $kombu_failover_strategy,
    rabbit_use_ssl          => $rabbit_use_ssl,
    rabbit_ha_queues        => $rabbit_ha_queues,
    amqp_durable_queues     => $amqp_durable_queues,
  }

  oslo::messaging::default { 'designate_config':
    transport_url        => $default_transport_url,
    rpc_response_timeout => $rpc_response_timeout,
    control_exchange     => $control_exchange,
  }

  oslo::messaging::notifications { 'designate_config':
    driver        => $notification_driver,
    transport_url => $notification_transport_url,
    topics        => $notification_topics,
  }

  # default setting
  designate_config {
    'DEFAULT/root_helper'               : value => $root_helper;
    'DEFAULT/state_path'                : value => $::designate::params::state_path;
    'network_api:neutron/endpoint_type' : value => $neutron_endpoint_type;
  }

}
