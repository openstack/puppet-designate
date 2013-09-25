# Configures the designate database
# This class will install the required libraries depending on the driver
# specified in the connection_string parameter
#
# == Parameters
#  [*database_connection*]
#    the connection string. format: [driver]://[user]:[password]@[host]/[database]
#
class designate::db (
  $database_connection = 'mysql://designate:designate@localhost/designate'
) {

  include designate::params

  Package<| title == 'designate-common' |> -> Class['designate::db']

  case $database_connection {
    /^mysql:\/\//: {
      $backend_package = false
      include mysql::python
    }
    default: {
      fail('Unsupported backend configured')
    }
  }

  if $backend_package and !defined(Package[$backend_package]) {
    package {'designate-backend-package':
      ensure => present,
      name   => $backend_package,
    }
  }

  designate_config {
    'storage:sqlalchemy/database_connection': value => $database_connection;
  }

  designate_config['storage:sqlalchemy/database_connection'] ~> Exec['designate-dbsync']

  exec { 'designate-dbsync':
    command     => $::designate::params::dbsync_command,
    path        => '/usr/bin',
    user        => 'root',
    refreshonly => true,
    logoutput   => on_failure,
    subscribe   => designate_config['storage:sqlalchemy/database_connection']
  }

}
