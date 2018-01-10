# == Class designate::backend::bind9
#
# Configure bind9 as backend
#
# == Parameters
#
# [*rndc_config_file*]
#   (optional) Location of the rndc configuration file.
#   Defaults to '/etc/rndc.conf'
#
# [*rndc_key_file*]
#  (optional) Location of the rndc key file.
#  Defaults to '/etc/rndc.key'
#
# [*rndc_host*]
#  (optional) Host running DNS service.
#  Defaults to '127.0.0.1'
#
# [*rndc_port*]
#  (optional) Port to use for dns service on rndc_host.
#  Defaults to '953'
#
class designate::backend::bind9 (
  $rndc_host           = '127.0.0.1',
  $rndc_port           = '953',
  $rndc_config_file    = '/etc/rndc.conf',
  $rndc_key_file       = '/etc/rndc.key',
) {

  include ::designate::deps
  include ::designate
  include ::dns

  designate_config {
    'backend:bind9/rndc_host'        : value => $rndc_host;
    'backend:bind9/rndc_port'        : value => $rndc_port;
    'backend:bind9/rndc_config_file' : value => $rndc_config_file;
    'backend:bind9/rndc_key_file'    : value => $rndc_key_file;
  }

  concat::fragment { 'dns allow-new-zones':
    target  => $::dns::optionspath,
    content => 'allow-new-zones yes;',
    order   => '20',
  }

  # /var/named is root:named on RedHat and /var/cache/bind is root:bind on
  # Debian. Both groups only have read access but require write permission in
  # order to be able to use rndc addzone/delzone commands that Designate uses.
  # NOTE(bnemec): ensure_resource is to avoid a chicken and egg problem with
  # removing this from puppet-openstack-integration.  Once that has been done
  # the ensure_resource wrapper could be removed.
  ensure_resource('file', $::dns::params::vardir, {
    mode    => 'g+w',
    require => Package[$::dns::params::dns_server_package]
  })
}
