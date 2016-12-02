require 'spec_helper_acceptance'

describe 'basic designate' do

  context 'default parameters' do

    it 'should work with no errors' do
      pp= <<-EOS
      include ::openstack_integration
      include ::openstack_integration::repos
      include ::openstack_integration::rabbitmq
      include ::openstack_integration::mysql
      include ::openstack_integration::keystone

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

      # Designate resources
      class { '::designate::db::mysql':
        password => 'a_big_secret',
      }
      class { '::designate::keystone::auth':
        password => 'a_big_secret',
      }
      class { '::designate':
        default_transport_url => 'rabbit://designate:an_even_bigger_secret@127.0.0.1:5672/',
        debug                 => true,
      }
      class { '::designate::keystone::authtoken':
        password => 'a_big_secret',
      }
      class { '::designate::api':
        enabled       => true,
        auth_strategy => 'keystone',
      }
      include ::designate::central
      class { '::designate::backend::bind9':
        rndc_config_file => '',
        rndc_key_file    => '',
      }
      include ::designate::client
      class { '::designate::agent': }
      class { '::designate::db':
        database_connection => 'mysql+pymysql://designate:a_big_secret@127.0.0.1/designate?charset=utf8',
      }
      EOS

      # Run it twice and test for idempotency
      apply_manifest(pp, :catch_failures => true)
      apply_manifest(pp, :catch_changes => true)
    end

    describe port(9001) do
      it { is_expected.to be_listening.with('tcp') }
    end
  end
end
