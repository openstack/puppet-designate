# == Class designate::backend::powerdns
#
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

  include ::designate::deps
  include ::designate
  include ::powerdns
  include ::powerdns::mysql

  # The Ubuntu packages install several example config files in here, but only
  # one of them can exist, since they all load different powerdns backends.  We
  # purge all others so that powerdns will do what the puppet module needs.
  File <| title == '/etc/powerdns/pdns.d' |> {
    purge   => true,
    recurse => true,
  }

  designate_config {
    'backend:powerdns/connection':       value => $database_connection, secret => true;
    'backend:powerdns/use_db_reconnect': value => $use_db_reconnect;
  }

  if $sync_db {
    include ::designate::db::powerdns::sync
  }
}
