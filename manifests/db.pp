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
class designate::db (
  $database_connection = 'mysql://designate:designate@localhost/designate'
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

  exec { 'designate-dbsync':
    command     => $::designate::params::dbsync_command,
    path        => '/usr/bin',
    user        => 'root',
    refreshonly => true,
    logoutput   => on_failure,
    # Config and software must be installed before running dbsync, and if either
    # one changes, then run it again.
    subscribe   => [
      Anchor['designate::install::end'],
      Anchor['designate::config::end'],
    ],
    notify      => Anchor['designate::service::begin'],
  }
}
