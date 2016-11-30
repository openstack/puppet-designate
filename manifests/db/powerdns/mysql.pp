# == Class: designate::db::powerdns::mysql
#
# Class that configures mysql for the designate PowerDNS backend.
#
# === Parameters:
#
# [*password*]
#   Password to use for the powerdns user
#
# [*dbname*]
#   (optional) The name of the database
#   Defaults to 'powerdns'
#
# [*user*]
#   (optional) The mysql user to create
#   Defaults to 'powerdns'
#
# [*host*]
#   (optional) The IP address of the mysql server
#   Defaults to '127.0.0.1'
#
# [*charset*]
#   (optional) The charset to use for the powerdns database
#   Defaults to 'utf8'
#
# [*collate*]
#   (optional) The collate to use for the powerdns database
#   Defaults to 'utf8_general_ci'
#
# [*allowed_hosts*]
#   (optional) Additional hosts that are allowed to access this DB
#   Defaults to undef
#
class designate::db::powerdns::mysql (
  $password,
  $dbname           = 'powerdns',
  $user             = 'powerdns',
  $host             = '127.0.0.1',
  $charset          = 'utf8',
  $collate          = 'utf8_general_ci',
  $allowed_hosts    = undef,
) {

  include ::designate::deps

  ::openstacklib::db::mysql { 'powerdns':
    user          => $user,
    password_hash => mysql_password($password),
    dbname        => $dbname,
    host          => $host,
    charset       => $charset,
    collate       => $collate,
    allowed_hosts => $allowed_hosts,
  }

  Anchor['designate::db::begin']
  ~> Class['designate::db::powerdns::mysql']
  ~> Anchor['designate::db::end']

}
