# Params
#
class designate::params {
  $state_path              =  '/var/lib/designate'
  # bind path
  $designatepath           = "${state_path}/bind9"
  $designatefile           = "${state_path}/bind9/zones.config"
  # Log dir
  $log_dir                 =  '/var/log/designate'
  $client_package_name     =  'python-designateclient'

  case $::osfamily {
    'RedHat': {
      # package name
      $common_package_name       = 'openstack-designate'
      $api_package_name          = 'openstack-designate-api'
      $central_package_name      = 'openstack-designate-central'
      $agent_package_name        = 'openstack-designate-agent'
      $sink_package_name         = 'openstack-designate-sink'
      $pymysql_package_name      = undef
      $mdns_package_name         = 'openstack-designate-mdns'
      $pool_manager_package_name = 'openstack-designate-pool-manager'
      # service names
      $agent_service_name        = 'openstack-designate-agent'
      $api_service_name          = 'openstack-designate-api'
      $central_service_name      = 'openstack-designate-central'
      $sink_service_name         = 'openstack-designate-sink'
      $mdns_service_name         = 'openstack-designate-mdns'
      $pool_manager_service_name = 'openstack-designate-pool-manager'
    }
    'Debian': {
      # package name
      $common_package_name       = 'designate-common'
      $api_package_name          = 'designate-api'
      $central_package_name      = 'designate-central'
      $agent_package_name        = 'designate-agent'
      $sink_package_name         = 'designate-sink'
      $pymysql_package_name      = 'python-pymysql'
      $pool_manager_package_name = 'openstack-designate-pool-manager'
      $mdns_package_name         = 'designate-mdns'
      # service names
      $agent_service_name        = 'designate-agent'
      $api_service_name          = 'designate-api'
      $central_service_name      = 'designate-central'
      $sink_service_name         = 'designate-sink'
      $mdns_service_name         = 'designate-mdns'
      $pool_manager_service_name = 'designate-pool-manager'
    }
    default: {
      fail("Unsupported osfamily: ${::osfamily} operatingsystem")
    }
  }
}
