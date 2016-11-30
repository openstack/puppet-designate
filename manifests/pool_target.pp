# == Define: designate::pool_target
#
# Configure a target for the Designate Pool Manager.
#
# == Parameters
#
# [*options*]
#   Options to be passed to the backend DNS server. This should include host and
#   port. For instance for a bind9 target this could be:
#     {'rndc_host'        => '192.168.27.100',
#      'rndc_port'        => 953,
#      'rndc_config_file' => '/etc/bind/rndc.conf',
#      'rndc_key_file'    => '/etc/bind/rndc.key',
#      'port'             => 53,
#      'host'             => '192.168.27.100'}
#
# [*type*]
#   Port number of the target DNS server.
#
# [*masters*]
#   (optional) IP addresses and ports of the master DNS server. This should point
#   to the Designate mDNS servers and ports.
#   Defaults to ['127.0.0.1:5354']
#
define designate::pool_target (
  $options,
  $type,
  $masters = ['127.0.0.1:5354'],
) {

  include ::designate::deps

  if target == 'powerdns' {
    include ::powerdns
    include ::powerdns::mysql
  }

  validate_re($name, '[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}')
  validate_array($masters)

  if is_hash($options) {
    $options_real = join(join_keys_to_values($options,':'),',')
  } else {
    warning('Passing a string to options is now deprecated, use a hash instead.')
    $options_real = $options
  }

  designate_config {
    "pool_target:${name}/options": value => $options_real;
    "pool_target:${name}/type":    value => $type;
    "pool_target:${name}/masters": value => join($masters,',');
  }

  if $type == 'powerdns' {
    exec { "designate-powerdns-dbsync ${name}":
      command     => "${::designate::params::designate_manage} powerdns sync ${name}",
      path        => '/usr/bin',
      user        => 'root',
      refreshonly => true,
      logoutput   => on_failure,
    }

    # Have to have a valid configuration file before running migrations
    Designate_config<||> -> Exec["designate-powerdns-dbsync ${name}"]
    Exec["designate-powerdns-dbsync ${name}"] ~> Service<| title == 'designate-pool-manager' |>
  }
}
