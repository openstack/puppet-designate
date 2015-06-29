#
# Class to execute designate powerdns dbsync
#
class designate::db::powerdns::sync {

  include ::designate::params

  exec { 'designate-powerdns-dbsync':
    command     => $::designate::params::powerdns_dbsync_command,
    path        => '/usr/bin',
    user        => 'root',
    refreshonly => true,
    logoutput   => on_failure,
    subscribe   => Anchor['designate::config::end'],
    notify      => Anchor['designate::service::begin'],
  }


}
