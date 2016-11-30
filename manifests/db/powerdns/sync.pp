#
# Class to execute designate powerdns dbsync
#
# ==Parameters
#
# [*extra_params*]
#   (optional) String of extra command line parameters to append
#   to the designate-manage powerdns sync command. These will be
#   inserted in the command line between 'designate-manage' and
#   'powerdns sync'.
#   Defaults to undef
class designate::db::powerdns::sync(
  $extra_params = undef,
) {

  include ::designate::deps
  include ::designate::params

  exec { 'designate-powerdns-dbsync':
    command     => "designate-manage ${extra_params} powerdns sync",
    path        => '/usr/bin',
    user        => 'root',
    refreshonly => true,
    logoutput   => on_failure,
    subscribe   => [
      Anchor['designate::install::end'],
      Anchor['designate::config::end'],
      Anchor['designate::dbsync::begin']
    ],
    notify      => Anchor['designate::dbsync::end'],
  }


}
