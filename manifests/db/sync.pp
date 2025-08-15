#
# Class to execute designate dbsync
#
# ==Parameters
#
# [*extra_params*]
#   (Optional) String of extra command line parameters to append
#   to the designate-manage database sync command. These will be
#   inserted in the command line between 'designate-manage' and
#   'database sync'.
#   Defaults to undef
#
# [*db_sync_timeout*]
#   (Optional) Timeout for the execution of the db_sync
#   Defaults to 300
#
class designate::db::sync(
  $extra_params    = undef,
  $db_sync_timeout = 300,
) {

  include designate::deps
  include designate::params

  exec { 'designate-dbsync':
    command     => "designate-manage ${extra_params} database sync",
    path        => '/usr/bin',
    user        => $designate::params::user,
    refreshonly => true,
    try_sleep   => 5,
    tries       => 10,
    timeout     => $db_sync_timeout,
    logoutput   => on_failure,
    subscribe   => [
      Anchor['designate::install::end'],
      Anchor['designate::config::end'],
      Anchor['designate::dbsync::begin']
    ],
    notify      => Anchor['designate::dbsync::end'],
    tag         => 'openstack-db',
  }

}
