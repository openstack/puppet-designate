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

  include ::designate::deps

  exec { 'designate-dbsync':
    command     => "designate-manage ${extra_params} database sync",
    path        => '/usr/bin',
    user        => 'root',
    refreshonly => true,
    try_sleep   => 5,
    tries       => 10,
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
