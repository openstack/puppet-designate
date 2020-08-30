# == Class designate::db
#
# Configures the designate database
#
# This class will install the required libraries depending on the driver
# specified in the connection_string parameter
#
# == Parameters
#
# [*database_db_max_retries*]
#   (optional) Maximum retries in case of connection error or deadlock error
#   before error is raised. Set to -1 to specify an infinite retry count.
#   Defaults to $::os_service_default
#
# [*database_connection*]
#   Url used to connect to database.
#   (Optional) Defaults to 'mysql://designate:designate@localhost/designate'.
#
# [*database_connection_recycle_time*]
#   Timeout when db connections should be reaped.
#   (Optional) Defaults to $::os_service_default
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
# [*database_pool_timeout*]
#   (Optional) If set, use this value for pool_timeout with SQLAlchemy.
#   Defaults to $::os_service_default
#
# [*mysql_enable_ndb*]
#   (Optional) If True, transparently enables support for handling MySQL
#   Cluster (NDB).
#   Defaults to $::os_service_default
#
# [*sync_db*]
#   (Optional) Run db sync on nodes after connection setting has been set.
#   Defaults to true
#
# DEPRECATED PARAMETERS
#
# [*database_idle_timeout*]
#   Timeout when db connections should be reaped.
#   (Optional) Defaults to undef.
#
# [*database_min_pool_size*]
#   Minimum number of SQL connections to keep open in a pool.
#   (Optional) Defaults to undef.
#
class designate::db (
  $database_db_max_retries          = $::os_service_default,
  $database_connection              = 'mysql://designate:designate@localhost/designate',
  $database_max_pool_size           = 10,
  $database_connection_recycle_time = $::os_service_default,
  $database_max_retries             = 10,
  $database_retry_interval          = 10,
  $database_max_overflow            = 20,
  $database_pool_timeout            = $::os_service_default,
  $mysql_enable_ndb                 = $::os_service_default,
  $sync_db                          = true,
  # DEPRECATED PARAMETERS
  $database_idle_timeout            = undef,
  $database_min_pool_size           = undef,
) {

  include designate::deps

  if $database_idle_timeout != undef {
    warning('The database_min_pool_size parameter is deprecated, and will be \
removed in a future release.')
  }

  if $database_min_pool_size != undef {
    warning('The database_min_pool_size parameter is deprecated, and will be \
removed in a future release.')
  }

  oslo::db { 'designate_config':
    config_group            => 'storage:sqlalchemy',
    db_max_retries          => $database_db_max_retries,
    connection              => $database_connection,
    connection_recycle_time => $database_connection_recycle_time,
    max_retries             => $database_max_retries,
    retry_interval          => $database_retry_interval,
    max_pool_size           => $database_max_pool_size,
    max_overflow            => $database_max_overflow,
    pool_timeout            => $database_pool_timeout,
    mysql_enable_ndb        => $mysql_enable_ndb,
  }

  if $sync_db {
    include designate::db::sync
  }

}
