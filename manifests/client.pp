# == Class designate::client
#
# Installs the designate python library.
#
# == Parameters
#
#  [*ensure*]
#    (optional) Ensure state for pachage.
#    Defaults to 'present'
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
