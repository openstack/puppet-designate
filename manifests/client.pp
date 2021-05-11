# == Class designate::client
#
# Installs the designate python library.
#
# == Parameters
#
# [*package_ensure*]
#   (optional) Ensure state for pachage.
#   Defaults to 'present'
#
# [*client_package_name*]
#  (optional) Name of the package containing client resources
#  Defaults to $::designate::params::client_package_name
#
class designate::client (
  $package_ensure = 'present',
  $client_package_name = $::designate::params::client_package_name,
) inherits designate::params {

  include designate::deps

  package { 'python-designateclient':
    ensure => $package_ensure,
    name   => $client_package_name,
    tag    => 'openstack',
  }

  include openstacklib::openstackclient

}
