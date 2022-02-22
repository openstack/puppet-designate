# == Class designate::backend::agent
#
# Configure agent as backend
#
# == Parameters
#
# [*agent_hosts*]
#  (Optional) Host running designate-agent service.
#  Defaults to ['127.0.0,1'].
#
# [*agent_port*]
#  (Optional) TCP port to connect to designate-agent service.
#  Defaults to 5358.
#
# [*mdns_hosts*]
#  (Optional) Array of hosts where designate-mdns service is running.
#  Defaults to ['127.0.0.1'].
#
# [*mdns_port*]
#  (Optional) TCP Port to connect to designate-mdns service.
#  Defaults to 5354.
#
# [*manage_pool*]
#  (Optional) Manage pools.yaml and update pools by designate-manage command
#  Defaults to true
#
class designate::backend::agent (
  $agent_hosts = ['127.0.0.1'],
  $agent_port  = 5358,
  $mdns_hosts  = ['127.0.0.1'],
  $mdns_port   = 5354,
  $manage_pool = true,
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
      content => template('designate/agent-pools.yaml.erb'),
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
