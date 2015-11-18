#
# Class to execute designate dbsync
#
# ==Parameters
#
# [*extra_params*]
#   (optional) String of extra command line parameters to append
#   to the designate-manage database sync command. These will be
#   inserted in the command line between 'designate-manage' and
#   'database sync'.
#   Defaults to undef
#
class designate::db::sync(
  $extra_params = undef,
) {

  include ::designate::params

  exec { 'designate-dbsync':
    command     => "designate-manage ${extra_params} database sync",
    path        => '/usr/bin',
    user        => 'root',
    refreshonly => true,
    logoutput   => on_failure,
    subscribe   => Anchor['designate::config::end'],
    notify      => Anchor['designate::service::begin'],
  }

}
