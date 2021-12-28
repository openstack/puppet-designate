#
# Unit tests for designate::init
#
require 'spec_helper'

describe 'designate' do

  let :params do
    {
      :package_ensure        => 'installed',
      :purge_config          => false,
      :neutron_endpoint_type => 'internalURL',
      :root_helper           => 'sudo designate-rootwrap /etc/designate/rootwrap.conf'
    }
  end

  let :rabbit_use_ssl do
    {
      :rabbit_use_ssl          => true,
      :kombu_ssl_ca_certs      => 'ca goes here',
      :kombu_ssl_certfile      => 'cert goes here',
      :kombu_ssl_keyfile       => 'key goes here',
      :kombu_ssl_version       => 'TLSv1',
      :kombu_reconnect_delay   => '1.0',
      :kombu_failover_strategy => 'shuffle',
    }
  end

  let :rabbit_use_ssl_cert_no_key do
    {
      :rabbit_use_ssl          => true,
      :kombu_ssl_ca_certs      => 'ca goes here',
      :kombu_ssl_certfile      => 'cert goes here',
      :kombu_ssl_version       => 'TLSv1',
      :kombu_reconnect_delay   => '1.0',
      :kombu_failover_strategy => 'shuffle',
    }
  end

  let :rabbit_use_ssl_key_no_cert do
    {
      :rabbit_use_ssl          => true,
      :kombu_ssl_ca_certs      => 'ca goes here',
      :kombu_ssl_keyfile       => 'key goes here',
      :kombu_ssl_version       => 'TLSv1',
      :kombu_reconnect_delay   => '1.0',
      :kombu_failover_strategy => 'shuffle',
    }
  end

  shared_examples_for 'designate' do

    context 'with transport parameter' do
      it_configures 'a designate base installation'
      it_configures 'rabbit transport'
      it_configures 'rabbit with SSL support'
      it_configures 'rabbit with SSL no key'
      it_configures 'rabbit with SSL no cert'
    end

    context 'with custom package name' do
      let :platform_params do
        { :common_package_name => 'designate-common-custom-name' }
      end

      before do
        params.merge!({ :common_package_name => 'designate-common-custom-name' })
      end

      it_configures 'a designate base installation'
    end

    context 'without state_path' do
      it { is_expected.to contain_designate_config('DEFAULT/state_path').with_value('/var/lib/designate') }
    end

    context 'with state_path' do
      let :params do
        { :state_path => '/var/tmp/designate' }
      end

      it { is_expected.to contain_designate_config('DEFAULT/state_path').with_value('/var/tmp/designate') }
    end
  end

  shared_examples_for 'a designate base installation' do

    it { is_expected.to contain_class('designate::deps') }
    it { is_expected.to contain_class('designate::params') }

    it 'installs designate common package' do
      is_expected.to contain_package('designate-common').with(
        :ensure => 'installed',
        :name   => platform_params[:common_package_name],
        :tag    => ['openstack', 'designate-package'],
      )
    end

    it 'passes purge to resource' do
      is_expected.to contain_resources('designate_config').with({
        :purge => false
      })
    end

    it 'configures root_helper' do
      is_expected.to contain_designate_config('DEFAULT/root_helper').with_value( params[:root_helper] )
    end

    it 'configures network endpoint type to use' do
      is_expected.to contain_designate_config('network_api:neutron/endpoint_type').with_value( params[:neutron_endpoint_type] )
    end

    it 'configures notification' do
      is_expected.to contain_designate_config('oslo_messaging_notifications/driver').with_value('messaging' )
      is_expected.to contain_designate_config('oslo_messaging_notifications/topics').with_value('notifications')
      is_expected.to contain_designate_config('oslo_messaging_notifications/transport_url').with_value('<SERVICE DEFAULT>')
      is_expected.to contain_designate_config('oslo_messaging_rabbit/heartbeat_in_pthread').with_value('<SERVICE DEFAULT>')
      is_expected.to contain_designate_config('DEFAULT/transport_url').with_value('<SERVICE DEFAULT>')
      is_expected.to contain_designate_config('DEFAULT/rpc_response_timeout').with_value('<SERVICE DEFAULT>')
      is_expected.to contain_designate_config('DEFAULT/control_exchange').with_value('<SERVICE DEFAULT>')
    end

  end

  shared_examples_for 'rabbit transport' do
    before do
      params.merge!({
        :default_transport_url       => 'rabbit://designate:secret@127.0.0.1:5672/designate',
        :rabbit_ha_queues            => true,
        :rabbit_heartbeat_in_pthread => true,
      })
    end

    it { is_expected.to contain_designate_config('DEFAULT/transport_url').with_value('rabbit://designate:secret@127.0.0.1:5672/designate') }
    it { is_expected.to contain_designate_config('oslo_messaging_rabbit/rabbit_ha_queues').with_value(true) }
    it { is_expected.to contain_designate_config('oslo_messaging_rabbit/heartbeat_in_pthread').with_value(true) }
    it { is_expected.to contain_designate_config('oslo_messaging_rabbit/amqp_durable_queues').with_value('<SERVICE DEFAULT>') }

  end

  shared_examples_for 'rabbit with SSL support' do
    before { params.merge!( rabbit_use_ssl ) }

    it 'configures rabbit with ssl' do
      is_expected.to contain_designate_config('oslo_messaging_rabbit/kombu_reconnect_delay').with_value( params[:kombu_reconnect_delay] )
      is_expected.to contain_designate_config('oslo_messaging_rabbit/kombu_failover_strategy').with_value( params[:kombu_failover_strategy] )
      is_expected.to contain_oslo__messaging__rabbit('designate_config').with(
        :rabbit_use_ssl     => params[:rabbit_use_ssl],
        :kombu_ssl_ca_certs => params[:kombu_ssl_ca_certs],
        :kombu_ssl_certfile => params[:kombu_ssl_certfile],
        :kombu_ssl_keyfile  => params[:kombu_ssl_keyfile],
        :kombu_ssl_version  => params[:kombu_ssl_version],
      )
    end
  end

  shared_examples_for 'rabbit with SSL no key' do
    before { params.merge!( rabbit_use_ssl_cert_no_key ) }

    it 'should fail' do
      is_expected.to raise_error(/The kombu_ssl_certfile and kombu_ssl_keyfile parameters must be used together/)
    end
  end

  shared_examples_for 'rabbit with SSL no cert' do
    before { params.merge!( rabbit_use_ssl_key_no_cert ) }

    it 'should fail' do
      is_expected.to raise_error(/The kombu_ssl_certfile and kombu_ssl_keyfile parameters must be used together/)
    end
  end

  on_supported_os({
    :supported_os => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts())
      end

      let(:platform_params) do
        case facts[:osfamily]
        when 'Debian'
          { :common_package_name => 'designate-common' }
        when 'RedHat'
          { :common_package_name => 'openstack-designate-common' }
        end
      end
      it_behaves_like 'designate'
    end
  end
end
