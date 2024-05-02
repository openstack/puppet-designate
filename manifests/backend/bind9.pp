# == Class designate::backend::bind9
#
# Configure bind9 as backend
#
# == Parameters
#
# [*rndc_config_file*]
#  (Optional) Location of the rndc configuration file.
#  Defaults to '/etc/rndc.conf'
#
# [*rndc_key_file*]
#  (Optional) Location of the rndc key file.
#  Defaults to '/etc/rndc.key'
#
# [*rndc_port*]
#  (Optional) RNDC Port.
#  Defaults to 953.
#
# [*rndc_controls*]
#  (Optional) Hash defining controls configuration for rndc.
#  Defaults to undef, which uses the puppet-dns default
#
# [*ns_records*]
#  (Optional) List of the NS records for zones hosted within this pool. This
#  parameter takes hash value of <priority>:<host> mapping.
#  Defaults to {1 => 'ns1.example.org.'}
#
# [*nameservers*]
#  (Optional) List out the nameservers for this pool.
#  Defaults to ['127.0.0,1'].
#
# [*bind9_hosts*]
#  (Optional) Host running DNS service.
#  Defaults to ['127.0.0,1'].
#
# [*dns_port*]
#  (Optional) TCP port to connect to DNS service.
#  Defaults to 53.
#
# [*mdns_hosts*]
#  (Optional) Array of hosts where designate-mdns service is running.
#  Defaults to ['127.0.0.1'].
#
# [*mdns_port*]
#  (Optional) TCP Port to connect to designate-mdns service.
#  Defaults to 5354.
#
# [*clean_zonefile*]
#  (Optional) Removes zone files when a zone is deleted.
#  Defaults to false
#
# [*also_notifies*]
#  (Optional) Array of hosts for which designate-mdns will send DNS notify
#  packets to.
#  Defaults to [].
#
# [*attributes*]
#  (Optional) Pool attribtes used by scheduling.
#  Defaults to {}
#
# DEPRECATED PARAMETERS
#
# [*configure_bind*]
#  (Optional) Enables running bind9/named configuration for hosts where
#  designate and designate bind services are collocated.
#  Defaults to true
#
class designate::backend::bind9 (
  $rndc_config_file                      = '/etc/rndc.conf',
  $rndc_key_file                         = '/etc/rndc.key',
  $rndc_controls                         = undef,
  $rndc_port                             = 953,
  Hash[Integer, String] $ns_records      = {1 => 'ns1.example.org.'},
  Array[String[1], 1] $nameservers       = ['127.0.0.1'],
  Array[String[1], 1] $bind9_hosts       = ['127.0.0.1'],
  $dns_port                              = 53,
  Array[String[1], 1] $mdns_hosts        = ['127.0.0.1'],
  $mdns_port                             = 5354,
  Boolean $clean_zonefile                = false,
  Array[String[1]] $also_notifies        = [],
  Hash[String[1], String[1]] $attributes = {},
  # DEPRECATED PARAMETERS
  Boolean $configure_bind                = true,
) {

  include designate::deps
  include designate::params

  if $configure_bind {
    warning("Configuragion of BIND 9 by designate::backend::bind9 is deprecated \
and will be removed in a future release.")

    $dns_additional_options = {
      'allow-new-zones'   => 'yes',
      # Recommended by Designate docs as a mitigation for potential cache
      # poisoning attacks:
      # https://docs.openstack.org/designate/latest/admin/production-guidelines.html#bind9-mitigation
      'minimal-responses' => 'yes',
    }

    if $rndc_controls {
      class { 'dns':
        controls           => $rndc_controls,
        additional_options => $dns_additional_options,
      }
    } else {
      class { 'dns':
        additional_options => $dns_additional_options,
      }
    }
  }

  file { '/etc/designate/pools.yaml':
    ensure  => present,
    path    => '/etc/designate/pools.yaml',
    owner   => $designate::params::user,
    group   => $designate::params::group,
    mode    => '0640',
    content => template('designate/bind9-pools.yaml.erb'),
    require => Anchor['designate::config::begin'],
    before  => Anchor['designate::config::end'],
  }

  exec { 'designate-manage pool update':
    command     => 'designate-manage pool update',
    path        => '/usr/bin',
    user        => $designate::params::user,
    refreshonly => true,
    require     => Anchor['designate::service::end'],
    subscribe   => File['/etc/designate/pools.yaml'],
  }
}
