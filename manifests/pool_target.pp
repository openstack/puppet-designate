# == Define: designate::pool_target
#
# Configure a target for the Designate Pool Manager.
#
# == Parameters
#
# [*options*]
#   (required) Options to be passed to the backend DNS server. This should
#   include host and port. For instance for a bind9 target this could be:
#     {'rndc_host'        => '192.168.27.100',
#      'rndc_port'        => 953,
#      'rndc_config_file' => '/etc/bind/rndc.conf',
#      'rndc_key_file'    => '/etc/bind/rndc.key',
#      'port'             => 53,
#      'host'             => '192.168.27.100'}
#
# [*type*]
#   (required) Port number of the target DNS server.
#
# [*masters*]
#   (optional) IP addresses and ports of the master DNS server. This should point
#   to the Designate mDNS servers and ports.
#   Defaults to ['127.0.0.1:5354']
#
define designate::pool_target (
  Hash $options,
  $type,
  Array[String[1]] $masters = ['127.0.0.1:5354'],
) {

  warning('Support for pool-manager was deprecated.')

  include designate::deps

  $options_real = join(join_keys_to_values($options,':'),',')

  designate_config {
    "pool_target:${name}/options": value => $options_real;
    "pool_target:${name}/type":    value => $type;
    "pool_target:${name}/masters": value => join($masters,',');
  }
}
