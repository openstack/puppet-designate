# == Class designate::dns
#
# Configure dns for designate service
#   This class is deprecated, use designate::backend::bind9
#
# == Parameters
#
# DEPRECATED PARAMETERS
#
# [*designatepath*]
#   (optional) Directory for maintaining designate's state
#   Defaults to $designate::params::designatepath
#
# [*designatefile*]
#   (optional) File for maintaining designate's state
#   Defaults to $designate::params::designatefile
#
class designate::dns (
  # DEPRECRATED PARAMETERS
  $designatepath  = undef,
  $designatefile  = undef,
) {
  warning('The class designate::dns is depecrated. Use designate::backend::bind9 instead.')
  include ::designate::backend::bind9
}
