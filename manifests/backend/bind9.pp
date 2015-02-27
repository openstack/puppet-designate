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
  $rndc_host        = '127.0.0.1',
  $rndc_port        = '953',
  $rndc_config_file = '/etc/rndc.conf',
  $rndc_key_file    = '/etc/rndc.key'
) {
  include ::designate
  include ::dns

  designate_config {
    'backend:bind9/rndc_host'         : value => $rndc_host;
    'backend:bind9/rndc_port'         : value => $rndc_port;
    'backend:bind9/rndc_config_file'  : value => $rndc_config_file;
    'backend:bind9/rndc_key_file'     : value => $rndc_key_file;
  }

  file_line {'dns allow-new-zones':
    ensure  => present,
    path    => "${::dns::params::namedconf_path}.options",
    line    => 'allow-new-zones yes;',
    require => Class['::designate'],
  }

  Class['::dns'] -> User['designate']
  User<| title == 'designate' |> {
    groups +> $::dns::params::group,
  }

  file { '/var/lib/designate':
    ensure => directory,
    owner  => 'designate',
    group  => $::dns::params::group,
    mode   => '0750',
  }

}
