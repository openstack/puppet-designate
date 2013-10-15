#
# Installs the designate python library.
#
# == parameters
#  [*ensure*]
#    ensure state for pachage.
#
class designate::client (
  $ensure = 'present'
) {

  include designate::params

  package { 'python-designateclient':
    ensure => $ensure,
    name   => $::designate::params::client_package_name,
  }

}
