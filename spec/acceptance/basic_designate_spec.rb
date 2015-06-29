require 'spec_helper_acceptance'

describe 'basic designate' do

  context 'default parameters' do

    it 'should work with no errors' do
      ppp= <<-EOS
      case $::osfamily {
        'Debian': {
          Exec { logoutput => 'on_failure' }
          package { ['debconf-utils','debconf']: ensure => installed, } ->
          exec { 'fix_empty_rabbit_password':
            command  => '/bin/echo "designate-common designate/rabbit_password password password" | /usr/bin/debconf-set-selections',
            unless   => '/usr/bin/debconf-get-selections | grep "designate/rabbit_password"',
          }
          exec { 'fix_empty_keystone_password':
            command  => '/bin/echo "designate-common designate/admin-password password password" | /usr/bin/debconf-set-selections',
            unless   => '/usr/bin/debconf-get-selections | grep "designate/admin-password"',
          }
        }
      }
      EOS
      pp= <<-EOS
      Exec { logoutput => 'on_failure' }

      # Common resources
      case $::osfamily {
        'Debian': {
          include ::apt
          class { '::openstack_extras::repo::debian::ubuntu':
            release         => 'kilo',
            package_require => true,
          }
          $package_provider = 'apt'
        }
        'RedHat': {
          class { '::openstack_extras::repo::redhat::redhat':
            release => 'kilo',
          }
          package { 'openstack-selinux': ensure => 'latest' }
          $package_provider = 'yum'
        }
        default: {
          fail("Unsupported osfamily (${::osfamily})")
        }
      }

      class { '::mysql::server': }

      class { '::rabbitmq':
        delete_guest_user => true,
        package_provider  => $package_provider,
      }

      rabbitmq_vhost { '/':
        provider => 'rabbitmqctl',
        require  => Class['rabbitmq'],
      }

      rabbitmq_user { 'designate':
        admin    => true,
        password => 'an_even_bigger_secret',
        provider => 'rabbitmqctl',
        require  => Class['rabbitmq'],
      }

      rabbitmq_user_permissions { 'designate@/':
        configure_permission => '.*',
        write_permission     => '.*',
        read_permission      => '.*',
        provider             => 'rabbitmqctl',
        require              => Class['rabbitmq'],
      }

      # Keystone resources, needed by Designate to run
      class { '::keystone::db::mysql':
        password => 'keystone',
      }
      class { '::keystone':
        verbose             => true,
        debug               => true,
        database_connection => 'mysql://keystone:keystone@127.0.0.1/keystone',
        admin_token         => 'admin_token',
        enabled             => true,
      }
      class { '::keystone::roles::admin':
        email    => 'test@example.tld',
        password => 'a_big_secret',
      }
      class { '::keystone::endpoint':
        public_url => "https://${::fqdn}:5000/",
        admin_url  => "https://${::fqdn}:35357/",
      }

      case $::osfamily {
        'Debian': {
          # Designate resources
          class { '::designate::db::mysql':
            password => 'a_big_secret',
          }
          class { '::designate::keystone::auth':
            password => 'a_big_secret',
          }
          class { '::designate':
            rabbit_userid       => 'designate',
            rabbit_password     => 'an_even_bigger_secret',
            rabbit_host         => '127.0.0.1',
          }
          class { '::designate::api':
            enabled           => true,
            auth_strategy     => 'keystone',
            keystone_password => 'a_big_secret',
          }
          class { '::designate::backend::bind9':
            rndc_config_file => '',
            rndc_key_file    => '',
          }
          include ::designate::client
          class { '::designate::agent': }
          class { '::designate::db':
            database_connection => 'mysql://designate:a_big_secret@127.0.0.1/designate?charset=utf8',
          }
          include ::designate::dns
        }
        'RedHat': {
          warning("Designate packaging is not ready on ${::osfamily}.")
        }
      }
      EOS

      # TODO : A fix on inifile must be filed, if the value is an empty string, the inifile provider
      # configure the value with a newline.https://paste.debian.net/238471/
      apply_manifest(ppp, :catch_failures => true)
      # Run it once, idempotency does not work
      # this is what we have each time we run puppet after first time:
      # http://paste.openstack.org/show/2ebHALkNguNsE0804Oev/
      apply_manifest(pp, :catch_failures => true)
    end

    if os[:family] == 'Debian'
      describe port(9001) do
        it { is_expected.to be_listening.with('tcp') }
      end
    end

  end
end
