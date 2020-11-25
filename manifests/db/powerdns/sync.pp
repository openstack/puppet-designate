#
# DEPRECATED !!
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

  warning('The designate::db::powerdns::sync class has been deprecaed \
and has no effect. This class will be removed in a future release.')

}
