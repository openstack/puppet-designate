#
# Class to execute designate dbsync
#
class designate::db::sync {

  include ::designate::params

  exec { 'designate-dbsync':
    command     => $::designate::params::dbsync_command,
    path        => '/usr/bin',
    user        => 'root',
    refreshonly => true,
    logoutput   => on_failure,
    subscribe   => Anchor['designate::config::end'],
    notify      => Anchor['designate::service::begin'],
  }

}
