# == Class designate::db
#
# Configures the designate database
#
# This class will install the required libraries depending on the driver
# specified in the connection_string parameter
#
# == Parameters
#
# [*database_connection*]
#   Url used to connect to database.
#   (Optional) Defaults to 'mysql://designate:designate@localhost/designate'.
#
# [*database_idle_timeout*]
#   Timeout when db connections should be reaped.
#   (Optional) Defaults to 3600.
#
# [*database_min_pool_size*]
#   Minimum number of SQL connections to keep open in a pool.
#   (Optional) Defaults to 1.
#
# [*database_max_pool_size*]
#   Maximum number of SQL connections to keep open in a pool.
#   (Optional) Defaults to 10.
#
# [*database_max_retries*]
#   Maximum db connection retries during startup.
#   Setting -1 implies an infinite retry count.
#   (Optional) Defaults to 10.
#
# [*database_retry_interval*]
#   Interval between retries of opening a sql connection.
#   (Optional) Defaults to 10.
#
# [*database_max_overflow*]
#   If set, use this value for max_overflow with sqlalchemy.
#   (Optional) Defaults to 20.
#
# [*sync_db*]
#   (Optional) Run db sync on nodes after connection setting has been set.
#   Defaults to true
#
# [*sync_db*]
#   Enable dbsync.
#
class designate::db (
  $database_connection     = 'mysql://designate:designate@localhost/designate',
  $database_idle_timeout   = 3600,
  $database_min_pool_size  = 1,
  $database_max_pool_size  = 10,
  $database_max_retries    = 10,
  $database_retry_interval = 10,
  $database_max_overflow   = 20,
  $sync_db                 = true,
) {

  include ::designate::deps
  include ::designate::params

  validate_re($database_connection,
    '(mysql(\+pymysql)?):\/\/(\S+:\S+@\S+\/\S+)?')

  case $database_connection {
    /^mysql(\+pymysql)?:\/\//: {
      require '::mysql::bindings'
      require '::mysql::bindings::python'
      if $database_connection =~ /^mysql\+pymysql/ {
        $backend_package = $::designate::params::pymysql_package_name
      } else {
        $backend_package = false
      }
    }
    default: {
      fail('Unsupported backend configured')
    }
  }

  if $backend_package and !defined(Package[$backend_package]) {
    package {'designate-backend-package':
      ensure => present,
      name   => $backend_package,
      tag    => 'openstack',
    }
  }

  designate_config {
    'storage:sqlalchemy/connection':     value => $database_connection, secret => true;
    'storage:sqlalchemy/idle_timeout':   value => $database_idle_timeout;
    'storage:sqlalchemy/min_pool_size':  value => $database_min_pool_size;
    'storage:sqlalchemy/max_retries':    value => $database_max_retries;
    'storage:sqlalchemy/retry_interval': value => $database_retry_interval;
    'storage:sqlalchemy/max_pool_size':  value => $database_max_pool_size;
    'storage:sqlalchemy/max_overflow':   value => $database_max_overflow;
  }

  if $sync_db {
    include ::designate::db::sync
  }

}
