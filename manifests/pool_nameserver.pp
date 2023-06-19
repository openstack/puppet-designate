# Define: designate::pool_nameserver
#
# === Parameters
#
# [*port*]
#  (optional) Port number of the DNS server.
#  Defaults to 53.
#
# [*host*]
#  (optional) IP address or hostname of the DNS server.
#  Defaults to '127.0.0.1'
#
define designate::pool_nameserver(
  $port = 53,
  $host = '127.0.0.1',
){

  warning('Support for pool-manager was deprecated.')

  include designate::deps

  designate_config {
    "pool_nameserver:${name}/port": value => $port;
    "pool_nameserver:${name}/host": value => $host;
  }
}
