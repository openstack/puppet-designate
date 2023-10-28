# == Class designate::backend::pdns4
#
# Configure PowerDNS 4 as backend
#
# == Parameters
#
# [*api_token*]
#  (Required) Token string to authenticate with the PowerDNS Authoritative
#  Server.
#
# [*pdns4_hosts*]
#  (Optional) Host running DNS service.
#  Defaults to ['127.0.0,1'].
#
# [*pdns4_port*]
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
# [*api_endpoint*]
#  (Optional) URL to access the PowerDNS Authoritative Server.
#  Defaults to 'http://127.0.0.1:8081'.
#
# [*tsigkey_name*]
#  (Optional) Name of TSIGKey.
#  Defaults to undef.
#
# [*manage_pool*]
#  (Optional) Manage pools.yaml and update pools by designate-manage command
#  Defaults to true
#
class designate::backend::pdns4 (
  String[1] $api_token,
  Array[String[1], 1] $pdns4_hosts  = ['127.0.0.1'],
  $pdns4_port                       = 53,
  Array[String[1], 1] $mdns_hosts   = ['127.0.0.1'],
  $mdns_port                        = 5354,
  String[1] $api_endpoint           = 'http://127.0.0.1:8081',
  Optional[String[1]] $tsigkey_name = undef,
  Boolean $manage_pool              = true,
) {

  include designate::deps
  include designate::params

  if $manage_pool {
    file { '/etc/designate/pools.yaml':
      ensure  => present,
      path    => '/etc/designate/pools.yaml',
      owner   => $designate::params::user,
      group   => $designate::params::group,
      mode    => '0640',
      content => template('designate/pdns4-pools.yaml.erb'),
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
