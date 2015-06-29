# == Class designate::db
#
# Configures the designate database
#
# This class will install the required libraries depending on the driver
# specified in the connection_string parameter
#
# == Parameters
#
#  [*database_connection*]
#    the connection string. format: [driver]://[user]:[password]@[host]/[database]
#
#  [*sync_db*]
#    Enable dbsync.
#
class designate::db (
  $database_connection = 'mysql://designate:designate@localhost/designate',
  $sync_db             = true,
) {

  include ::designate::params

  case $database_connection {
    /^mysql:\/\//: {
      require 'mysql::bindings'
      require 'mysql::bindings::python'
    }
    default: {
      fail('Unsupported backend configured')
    }
  }

  designate_config {
    'storage:sqlalchemy/connection': value => $database_connection, secret => true;
  }

  if $sync_db {
    include ::designate::db::sync
  }

}
