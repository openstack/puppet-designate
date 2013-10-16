# Params

class designate::params {

  $dbinit_command      =  'designate-manage database-init'
  $dbsync_command      =  'designate-manage database-sync'
  $state_path          =  '/var/named/data'
  $log_dir             =  '/var/log/designate'
  $client_package_name =  'python-designateclient'

  case $::osfamily {
    'RedHat': {
       # package name
       $common_package_name   = 'openstack-designate'
       $api_package_name      = 'openstack-designate-api'
       $central_package_name  = 'openstack-designate-central'
       $agent_package_name    = 'openstack-designate-agent'
       $sink_package_name     = 'openstack-designate-sink'
       # service names
       $agent_service_name   = 'openstack-designate-agent'
       $api_service_name     = 'openstack-designate-api'
       $central_service_name = 'openstack-designate-central'
       $sink_service_name    = 'openstack-designate-sink'
       # bind path
       $designatepath        = "/var/named/data/bind9"
       $designatefile        = "/var/named/data/bind9/zones.config"
    }
  }
}





