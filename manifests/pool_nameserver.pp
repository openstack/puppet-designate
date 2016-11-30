# Define: designate::pool_nameserver
#
# === Parameters
#
# [*port*]
#  Port number of the DNS server.
#
# [*host*]
#  IP address or hostname of the DNS server.
#
define designate::pool_nameserver(
  $port = 53,
  $host = '127.0.0.1',
){

  include ::designate::deps

  validate_re($name, '[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}',
    'Name should be a UUID.')

  designate_config {
    "pool_nameserver:${name}/port": value => $port;
    "pool_nameserver:${name}/host": value => $host;
  }
}
