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
class designate::backend::powerdns (
  $database_connection,
  $use_db_reconnect = true,
) {
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

  file { '/var/lib/designate':
    ensure => directory,
    owner  => 'designate',
    group  => 'designate',
    mode   => '0750',
  }

  designate_config {
    'backend:powerdns/connection':       value => $database_connection, secret => true;
    'backend:powerdns/use_db_reconnect': value => $use_db_reconnect;
  }

  exec { 'designate-powerdns-dbsync':
    command     => $::designate::params::powerdns_dbsync_command,
    path        => '/usr/bin',
    user        => 'root',
    refreshonly => true,
    logoutput   => on_failure,
    subscribe   => Designate_config['backend:powerdns/connection'],
  }

  # Have to have a valid configuration file before running migrations
  Designate_config<||> -> Exec['designate-powerdns-dbsync']
  Exec['designate-powerdns-dbsync'] ~> Service<| title == 'designate-central' |>
}
