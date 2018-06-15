# == Class: designate::db::mysql
#
# Class that configures mysql for designate
#
# === Parameters:
#
# [*password*]
#   (Required) Password to use for the designate user
#
# [*dbname*]
#   (optional) The name of the database
#   Defaults to 'designate'
#
# [*user*]
#   (optional) The mysql user to create
#   Defaults to 'designate'
#
# [*host*]
#   (optional) The IP address of the mysql server
#   Defaults to '127.0.0.1'
#
# [*charset*]
#   (optional) The charset to use for the designate database
#   Defaults to 'utf8'
#
# [*collate*]
#   (optional) The collate to use for the designate database
#   Defaults to 'utf8_general_ci'
#
# [*allowed_hosts*]
#   (optional) Additional hosts that are allowed to access this DB
#   Defaults to undef
#
class designate::db::mysql(
  $password,
  $dbname        = 'designate',
  $user          = 'designate',
  $host          = '127.0.0.1',
  $charset       = 'utf8',
  $collate       = 'utf8_general_ci',
  $allowed_hosts = undef,
) {

  include ::designate::deps

  ::openstacklib::db::mysql { 'designate':
    user          => $user,
    password_hash => mysql_password($password),
    dbname        => $dbname,
    host          => $host,
    charset       => $charset,
    collate       => $collate,
    allowed_hosts => $allowed_hosts,
  }

  Anchor['designate::db::begin']
  ~> Class['designate::db::mysql']
  ~> Anchor['designate::db::end']

}
