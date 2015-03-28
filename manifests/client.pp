# == Class designate::client
#
# Installs the designate python library.
#
# == Parameters
#
# [*package_ensure*]
#   (optional) Ensure state for pachage.
#   Defaults to 'present'

# [*client_package_name*]
#  (optional) Name of the package containing client resources
#  Defaults to client_package_name from designate::params
#
class designate::client (
  $package_ensure = 'present',
  $client_package_name = undef,
) {

  include ::designate::params

  package { 'python-designateclient':
    ensure => $package_ensure,
    name   => pick($client_package_name, $::designate::params::client_package_name),
    tag    => 'openstack',
  }

}
