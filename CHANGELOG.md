##2016-05-20 - 7.1.0

###Summary

This is a maintenance release in the Liberty series.


##2015-11-25 - 7.0.0
###Summary

This is a backwards-incompatible major release for OpenStack Liberty.

####Backwards-incompatible changes
- change section name for AMQP rabbit parameters

####Features
- create designate::db::sync
- reflect provider change in puppet-openstacklib
- put all the logging related parameters to the logging class
- allow customization of db sync command line
- metadata: Add missing powerdns module
- use generic_service to manage services
- add enabled_notification_handlers option
- add related parameters to service::central section
- add designate_rootwrap_config in designate::config
- add notification related parameters to designate
- add hooks for external install & svc management

####Bugfixes
- rely on autorequire for config resource ordering

####Maintenance
- fix rspec 3.x syntax
- initial msync run for all Puppet OpenStack modules
- acceptance: enable debug & verbosity for OpenStack logs
- try to use zuul-cloner to prepare fixtures
- remove class_parameter_defaults puppet-lint check
- acceptance: use common bits from puppet-openstack-integration

##2015-10-10 - 6.1.0
###Summary

This is a maintenance release in the Kilo series.

####Maintenance
- acceptance: checkout stable/kilo puppet modules

##2015-07-08 - 6.0.0
###Summary

- Initial release of the puppet-designate module
