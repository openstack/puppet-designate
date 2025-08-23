# == Class: designate::db::postgresql
#
# Class that configures postgresql for designate
# Requires the Puppetlabs postgresql module.
#
# === Parameters
#
# [*password*]
#   (Required) Password to connect to the database.
#
# [*dbname*]
#   (Optional) Name of the database.
#   Defaults to 'designate'.
#
# [*user*]
#   (Optional) User to connect to the database.
#   Defaults to 'designate'.
#
# [*encoding*]
#   (Optional) The charset to use for the database.
#   Default to undef.
#
# [*privileges*]
#   (Optional) Privileges given to the database user.
#   Default to 'ALL'
#
class designate::db::postgresql (
  $password,
  $dbname      = 'designate',
  $user        = 'designate',
  $encoding    = undef,
  $privileges  = 'ALL',
) {
  include designate::deps

  openstacklib::db::postgresql { 'designate':
    password   => $password,
    dbname     => $dbname,
    user       => $user,
    encoding   => $encoding,
    privileges => $privileges,
  }

  Anchor['designate::db::begin']
  ~> Class['designate::db::postgresql']
  ~> Anchor['designate::db::end']
}
