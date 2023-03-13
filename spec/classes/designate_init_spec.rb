#
# Unit tests for designate::init
#
require 'spec_helper'

describe 'designate' do

  let :params do
    {
      :package_ensure => 'installed',
      :purge_config   => false,
      :root_helper    => 'sudo designate-rootwrap /etc/designate/rootwrap.conf'
    }
  end

  shared_examples_for 'designate' do

    context 'with transport parameter' do
      it_configures 'a designate base installation'
      it_configures 'rabbit transport'
      it_configures 'rabbit with SSL support'
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

    context 'without parameters' do
      it 'configures the default values' do
        is_expected.to contain_designate_config('DEFAULT/host').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_designate_config('DEFAULT/state_path').with_value('/var/lib/designate')
        is_expected.to contain_designate_config('DEFAULT/default_ttl').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_designate_config('DEFAULT/supported_record_type').with_value('<SERVICE DEFAULT>')
      end
    end

    context 'with parameters' do
      let :params do
        {
          :host                  => 'current_hostname',
          :state_path            => '/var/tmp/designate',
          :default_ttl           => 3600,
          :supported_record_type => 'A,AAAA'
        }
      end

      it 'configures the given values' do
        is_expected.to contain_designate_config('DEFAULT/host').with_value('current_hostname')
        is_expected.to contain_designate_config('DEFAULT/state_path').with_value('/var/tmp/designate')
        is_expected.to contain_designate_config('DEFAULT/default_ttl').with_value(3600)
        is_expected.to contain_designate_config('DEFAULT/supported_record_type').with_value('A,AAAA')
      end
    end

    context 'with supported_record_type (array)' do
      let :params do
        { :supported_record_type => ['A', 'AAAA'] }
      end

      it 'configures the given values' do
        is_expected.to contain_designate_config('DEFAULT/supported_record_type').with_value('A,AAAA')
      end
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

    it 'configures messaging' do
      is_expected.to contain_oslo__messaging__default('designate_config').with(
        :executor_thread_pool_size => '<SERVICE DEFAULT>',
        :transport_url             => '<SERVICE DEFAULT>',
        :rpc_response_timeout      => '<SERVICE DEFAULT>',
        :control_exchange          => '<SERVICE DEFAULT>'
      )
      is_expected.to contain_oslo__messaging__notifications('designate_config').with(
        :driver        => 'messaging',
        :transport_url => '<SERVICE DEFAULT>',
        :topics        => '<SERVICE DEFAULT>'
      )
      is_expected.to contain_oslo__messaging__rabbit('designate_config').with(
        :kombu_ssl_version       => '<SERVICE DEFAULT>',
        :kombu_ssl_keyfile       => '<SERVICE DEFAULT>',
        :kombu_ssl_certfile      => '<SERVICE DEFAULT>',
        :kombu_ssl_ca_certs      => '<SERVICE DEFAULT>',
        :kombu_reconnect_delay   => '<SERVICE DEFAULT>',
        :kombu_failover_strategy => '<SERVICE DEFAULT>',
        :rabbit_use_ssl          => '<SERVICE DEFAULT>',
        :rabbit_ha_queues        => '<SERVICE DEFAULT>',
        :heartbeat_in_pthread    => '<SERVICE DEFAULT>',
        :amqp_durable_queues     => '<SERVICE DEFAULT>',
      )
    end

  end

  shared_examples_for 'rabbit transport' do
    before do
      params.merge!({
        :default_transport_url       => 'rabbit://designate:secret@127.0.0.1:5672/designate',
        :rabbit_ha_queues            => true,
        :rabbit_heartbeat_in_pthread => true,
        :kombu_reconnect_delay       => '1.0',
        :kombu_failover_strategy     => 'shuffle',
      })
    end

    it { is_expected.to contain_oslo__messaging__default('designate_config').with(
      :transport_url => 'rabbit://designate:secret@127.0.0.1:5672/designate',
    ) }
    it { is_expected.to contain_oslo__messaging__rabbit('designate_config').with(
      :rabbit_ha_queues        => true,
      :heartbeat_in_pthread    => true,
      :kombu_reconnect_delay   => '1.0',
      :kombu_failover_strategy => 'shuffle'
    ) }

  end

  shared_examples_for 'rabbit with SSL support' do
    before { params.merge!(
      :rabbit_use_ssl     => true,
      :kombu_ssl_ca_certs => '/path/to/ssl/ca/certs',
      :kombu_ssl_certfile => '/path/to/ssl/cert/file',
      :kombu_ssl_keyfile  => '/path/to/ssl/keyfile',
      :kombu_ssl_version  => 'TLSv1',
    ) }

    it 'configures rabbit with ssl' do
      is_expected.to contain_oslo__messaging__rabbit('designate_config').with(
        :kombu_ssl_version  => params[:kombu_ssl_version],
        :kombu_ssl_keyfile  => params[:kombu_ssl_keyfile],
        :kombu_ssl_certfile => params[:kombu_ssl_certfile],
        :kombu_ssl_ca_certs => params[:kombu_ssl_ca_certs],
        :rabbit_use_ssl     => params[:rabbit_use_ssl],
      )
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
        case facts[:os]['family']
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
