# == Class designate::backend::powerdns
#
# DEPRECATED!
# Install PowerDNS and configure Designate to use it as a backend.  This does
# not configure PowerDNS itself since that is expected to be very environment
# specific.
#
# == Parameters
#
# [*database_connection*]
#  (required) The connection string. format:
#  [driver]://[user]:[password]@[host]/[database]
#
# [*use_db_reconnect*]
#  (optional) Whether or not to automatically reconnect and retry transactions.
#  Defaults to true
#
# [*sync_db*]
#  Enable dbsync.
#  Defaults to true
#
class designate::backend::powerdns (
  $database_connection,
  $use_db_reconnect = true,
  $sync_db          = true,
) {

  warning('The designate::backend::powerdns class has been deprecaed \
and has no effect. This class will be removed in a future release.')

}
