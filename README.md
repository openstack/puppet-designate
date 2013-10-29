puppet-designate
======


Module Description
------------------

The designate module aims to make Puppet capable of managing the entirely of designate.


WORK IN PROGRESS
----------------

✓ Basic structure  
✓ DB  
✓ Keystone (Users, Services, Endpoints)  
✓ Client  
✓ designate-api  
✓ designate-central  
✗ designate-agent (in progress)  
✗ designate-sink  (in progress)  
✓ An example of site.pp  
✗ Write Tests (in progress)  


Setup
-----

### Get Prepared for Deployment

    Currently there is no available RPM packages for use, you need to package it from source.

    First, clone the spec file from   https://github.com/NewpTone/designate-spec.git
    Then, clone the source file from  https://github.com/stackforge/designate.git
    Last, use rpmbuild to package it.

### Installing Designate

    You could ref the example file and install it.
