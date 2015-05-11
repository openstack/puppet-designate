require 'spec_helper_acceptance'

describe 'basic designate' do

  context 'default parameters' do

    it 'should work with no errors' do
      pp= <<-EOS
      Exec { logoutput => 'on_failure' }

      # Common resources
      include ::apt
      class { '::openstack_extras::repo::debian::ubuntu':
        release         => 'kilo',
        package_require => true,
      }

      class { '::mysql::server': }

      class { '::rabbitmq':
        delete_guest_user => true,
        erlang_cookie     => 'secrete',
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
      EOS


      # Run it once, idempotency does not work
      # this is what we have each time we run puppet after first time:
      # http://paste.openstack.org/show/2ebHALkNguNsE0804Oev/
      apply_manifest(pp, :catch_failures => true)
    end

    describe port(9001) do
      it { is_expected.to be_listening.with('tcp') }
    end

  end
end
