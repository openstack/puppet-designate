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
# [*host*]
#   (Optional) Name of this node.
#   Defaults to $facts['os_service_default']
#
# [*root_helper*]
#   (optional) Command for designate rootwrap helper.
#   Defaults to 'sudo designate-rootwrap /etc/designate/rootwrap.conf'.
#
# [*state_path*]
#   (optional) Directory for storing state.
#   Defaults to $::designate::params::state_path
#
# [*default_transport_url*]
#   (optional) A URL representing the messaging driver to use and its full
#   configuration. Transport URLs take the form:
#     transport://user:pass@host1:port[,hostN:portN]/virtual_host
#   Defaults to $facts['os_service_default']
#
# [*rpc_response_timeout*]
#  (Optional) Seconds to wait for a response from a call.
#  Defaults to $facts['os_service_default']
#
# [*control_exchange*]
#   (Optional) The default exchange under which topics are scoped. May be
#   overridden by an exchange name specified in the transport_url
#   option.
#   Defaults to $facts['os_service_default']
#
# [*notification_transport_url*]
#   (optional) Connection url for oslo messaging notification backend. An
#   example rabbit url would be, rabbit://user:pass@host:port/virtual_host
#   Defaults to $facts['os_service_default']
#
# [*rabbit_use_ssl*]
#   (optional) Connect over SSL for RabbitMQ
#   Defaults to $facts['os_service_default']
#
# [*rabbit_ha_queues*]
#   (optional) Use HA queues in RabbitMQ (x-ha-policy: all). If you change this
#   option, you must wipe the RabbitMQ database. (boolean value).
#   Defaults to $facts['os_service_default']
#
# [*rabbit_heartbeat_in_pthread*]
#   (Optional) EXPERIMENTAL: Run the health check heartbeat thread
#   through a native python thread. By default if this
#   option isn't provided the  health check heartbeat will
#   inherit the execution model from the parent process. By
#   example if the parent process have monkey patched the
#   stdlib by using eventlet/greenlet then the heartbeat
#   will be run through a green thread.
#   Defaults to $facts['os_service_default']
#
# [*kombu_ssl_ca_certs*]
#   (optional) SSL certification authority file (valid only if SSL enabled).
#   Defaults to $facts['os_service_default']
#
# [*kombu_ssl_certfile*]
#   (optional) SSL cert file (valid only if SSL enabled).
#   Defaults to $facts['os_service_default']
#
# [*kombu_ssl_keyfile*]
#   (optional) SSL key file (valid only if SSL enabled).
#   Defaults to $facts['os_service_default']
#
# [*kombu_ssl_version*]
#   (optional) SSL version to use (valid only if SSL enabled).
#   Valid values are TLSv1, SSLv23 and SSLv3. SSLv2 may be
#   available on some distributions.
#   Defaults to $facts['os_service_default']
#
# [*kombu_reconnect_delay*]
#   (optional) How long to wait before reconnecting in response to an AMQP
#   consumer cancel notification.
#   Defaults to $facts['os_service_default']
#
# [*kombu_failover_strategy*]
#   (Optional) Determines how the next RabbitMQ node is chosen in case the one
#   we are currently connected to becomes unavailable. Takes effect only if
#   more than one RabbitMQ node is provided in config. (string value)
#   Defaults to $facts['os_service_default']
#
# [*notification_driver*]
#   (optional) Driver used for issuing notifications
#   Defaults to 'messaging'
#
# [*notification_topics*]
#   (optional) Notification Topics
#   Defaults to $facts['os_service_default']
#
# [*purge_config*]
#   (optional) Whether to set only the specified config options
#   in the designate config.
#   Defaults to false
#
# [*amqp_durable_queues*]
#   (optional) Whether to use durable queues in AMQP.
#   Defaults to $facts['os_service_default'].
#
# [*default_ttl*]
#   (Optional) TTL Value.
#   Defaults to $facts['os_service_default'].
#
# [*supported_record_type*]
#   (Optional) Supported record types.
#   Defaults to $facts['os_service_default'].
#
class designate(
  $package_ensure              = present,
  $common_package_name         = $::designate::params::common_package_name,
  $host                        = $facts['os_service_default'],
  $root_helper                 = 'sudo designate-rootwrap /etc/designate/rootwrap.conf',
  $state_path                  = $::designate::params::state_path,
  $notification_transport_url  = $facts['os_service_default'],
  $rabbit_use_ssl              = $facts['os_service_default'],
  $rabbit_ha_queues            = $facts['os_service_default'],
  $rabbit_heartbeat_in_pthread = $facts['os_service_default'],
  $kombu_ssl_ca_certs          = $facts['os_service_default'],
  $kombu_ssl_certfile          = $facts['os_service_default'],
  $kombu_ssl_keyfile           = $facts['os_service_default'],
  $kombu_ssl_version           = $facts['os_service_default'],
  $kombu_reconnect_delay       = $facts['os_service_default'],
  $kombu_failover_strategy     = $facts['os_service_default'],
  $notification_driver         = 'messaging',
  $default_transport_url       = $facts['os_service_default'],
  $rpc_response_timeout        = $facts['os_service_default'],
  $control_exchange            = $facts['os_service_default'],
  $notification_topics         = $facts['os_service_default'],
  $purge_config                = false,
  $amqp_durable_queues         = $facts['os_service_default'],
  $default_ttl                 = $facts['os_service_default'],
  $supported_record_type       = $facts['os_service_default'],
) inherits designate::params {

  include designate::deps

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
    heartbeat_in_pthread    => $rabbit_heartbeat_in_pthread,
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
    'DEFAULT/host':                  value => $host;
    'DEFAULT/root_helper':           value => $root_helper;
    'DEFAULT/state_path' :           value => $state_path;
    'DEFAULT/default_ttl':           value => $default_ttl;
    'DEFAULT/supported_record_type': value => join(any2array($supported_record_type), ',');
  }

}
