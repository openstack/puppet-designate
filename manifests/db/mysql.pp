# The designate::db::mysql class creates a MySQL database for designate.
# It must be used on the MySQL server
#
# == Parameters
#
#  [*password*]
#    password to connect to the database. Mandatory.
#
#  [*dbname*]
#    name of the database. Optional. Defaults to designate.
#
#  [*user*]
#    user to connect to the database. Optional. Defaults to designate.
#
#  [*host*]
#    the default source host user is allowed to connect from.
#    Optional. Defaults to 'localhost'
#
#  [*allowed_hosts*]
#    other hosts the user is allowd to connect from.
#    Optional. Defaults to undef.
#
#  [*charset*]
#    the database charset. Optional. Defaults to 'latin1'
#
class designate::db::mysql(
  $password      = false,
  $dbname        = 'designate',
  $user          = 'designate',
  $host          = 'localhost',
  $allowed_hosts = undef,
  $charset       = 'latin1',
) {

  validate_string($password)

  Class['mysql::server'] -> Class['designate::db::mysql']
  Class['designate::db::mysql'] -> Exec<| title == 'designate-dbinit' |>
  Mysql::Db[$dbname] ~> Exec<| title == 'designate-dbinit' |>

  mysql::db { $dbname:
    user         => $user,
    password     => $password,
    host         => $host,
    charset      => $charset,
    require      => Class['mysql::config'],
  }

  # Check allowed_hosts to avoid duplicate resource declarations
  if is_array($allowed_hosts) and delete($allowed_hosts,$host) != [] {
    $real_allowed_hosts = delete($allowed_hosts,$host)
  } elsif is_string($allowed_hosts) and ($allowed_hosts != $host) {
    $real_allowed_hosts = $allowed_hosts
  }

  if $real_allowed_hosts {
    designate::db::mysql::host_access { $real_allowed_hosts:
      user      => $user,
      password  => $password,
      database  => $dbname,
    }
  }
}
