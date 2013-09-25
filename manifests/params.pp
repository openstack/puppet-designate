# Params

class designate::params {

  $dbsync_command =  'designate-manage database-init && designate-manage database-sync'
  $log_dir        =  '/var/named/data'

  case $::osfamily {
    'RedHat': {
       #package name
       $common_package_name   = 'openstack-designate'
       $api_package_name      = 'openstack-designate-api'
       $central_package_name  = 'openstack-designate-central'
       $sink_package_name     = 'openstack-designate-sink'
       # service names
       $agent_service_name   = 'openstack-designate-agent'
       $api_service_name     = 'openstack-designate-api'
       $central_service_name = 'openstack-designate-central'
    }
  }
}





