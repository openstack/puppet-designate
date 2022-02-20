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
# [*configure_bind*]
#  (Optional) Enables running bind9/named configuration for hosts where
#  designate and designate bind services are collocated.
#  Defaults to true
#
# [*manage_pool*]
#  (Optional) Manage pools.yaml and update pools by designate-manage command
#  Defaults to false
#
# DEPRECATED PARAMETERS
#
# [*rndc_host*]
#  (Optional) RNDC Host
#  Defaults to undef
#
class designate::backend::bind9 (
  $rndc_config_file = '/etc/rndc.conf',
  $rndc_key_file    = '/etc/rndc.key',
  $rndc_controls    = undef,
  $rndc_port        = 953,
  $ns_records       = {1 => 'ns1.example.org.'},
  $nameservers      = ['127.0.0.1'],
  $bind9_hosts      = ['127.0.0.1'],
  $dns_port         = 5322,
  $mdns_hosts       = ['127.0.0.1'],
  $mdns_port        = 5354,
  $configure_bind   = true,
  $manage_pool      = false,
  # DEPRECATED PARAMETERS
  $rndc_host        = undef,
) {

  include designate::deps
  include designate
  if $configure_bind {
    if $rndc_controls {
      class { 'dns':
        controls => $rndc_controls,
      }
    } else {
      include dns
    }
    concat::fragment { 'dns allow-new-zones':
      target  => $::dns::optionspath,
      content => 'allow-new-zones yes;',
      order   => '20',
    }

    # Recommended by Designate docs as a mitigation for potential cache
    # poisoning attacks:
    # https://docs.openstack.org/designate/latest/admin/production-guidelines.html#bind9-mitigation
    concat::fragment { 'dns minimal-responses':
      target  => $::dns::optionspath,
      content => 'minimal-responses yes;',
      order   => '21',
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

  # TODO(tkajinam): Remove this after Yoga release.
  if $rndc_host != undef {
    warning('The rndc_host parameter is deprecated and has no effect.')
  }

  # TODO(tkajinam): Remove this after Yoga release.
  designate_config {
    'backend:bind9/rndc_host'        : ensure => absent;
    'backend:bind9/rndc_port'        : ensure => absent;
    'backend:bind9/rndc_config_file' : ensure => absent;
    'backend:bind9/rndc_key_file'    : ensure => absent;
  }

  if $manage_pool {
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
}
