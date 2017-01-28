#
# Unit tests for designate::init
#
require 'spec_helper'

describe 'designate' do

  let :params do
    {
      :package_ensure     => 'installed',
      :debug              => 'False',
      :purge_config       => false,
      :root_helper        => 'sudo designate-rootwrap /etc/designate/rootwrap.conf'
    }
  end

  let :rabbit_ha_params do
    {
      :rabbit_hosts        => [ '10.0.0.1:5672', '10.0.0.2:5672', '10.0.0.3:5672' ],
      :rabbit_userid       => 'guest',
      :rabbit_password     => '',
      :rabbit_virtual_host => '/'
    }
  end

  let :rabbit_non_ha_params do
    {
      :rabbit_host         => '127.0.0.1',
      :rabbit_port         => 5672,
      :rabbit_userid       => 'guest',
      :rabbit_password     => '',
      :rabbit_virtual_host => '/'
    }
  end

  let :rabbit_deprecated_params do
    {
      :rabbit_virtualhost  => '/'
    }
  end

  let :rabbit_use_ssl do
    {
      :rabbit_host           => '127.0.0.1',
      :rabbit_port           => 5672,
      :rabbit_userid         => 'guest',
      :rabbit_password       => '',
      :rabbit_virtual_host   => '/',
      :rabbit_use_ssl        => true,
      :kombu_ssl_ca_certs    => 'ca goes here',
      :kombu_ssl_certfile    => 'cert goes here',
      :kombu_ssl_keyfile     => 'key goes here',
      :kombu_ssl_version     => 'TLSv1',
      :kombu_reconnect_delay => '1.0',
    }
  end

  let :rabbit_use_ssl_cert_no_key do
    {
      :rabbit_host           => '127.0.0.1',
      :rabbit_port           => 5672,
      :rabbit_userid         => 'guest',
      :rabbit_password       => '',
      :rabbit_virtual_host   => '/',
      :rabbit_use_ssl        => true,
      :kombu_ssl_ca_certs    => 'ca goes here',
      :kombu_ssl_certfile    => 'cert goes here',
      :kombu_ssl_version     => 'TLSv1',
      :kombu_reconnect_delay => '1.0',
    }
  end

  let :rabbit_use_ssl_key_no_cert do
    {
      :rabbit_host           => '127.0.0.1',
      :rabbit_port           => 5672,
      :rabbit_userid         => 'guest',
      :rabbit_password       => '',
      :rabbit_virtual_host   => '/',
      :rabbit_use_ssl        => true,
      :kombu_ssl_ca_certs    => 'ca goes here',
      :kombu_ssl_keyfile     => 'key goes here',
      :kombu_ssl_version     => 'TLSv1',
      :kombu_reconnect_delay => '1.0',
    }
  end

  shared_examples_for 'designate' do

    context 'with rabbit_host parameter' do
      it_configures 'a designate base installation'
      it_configures 'rabbit without HA support'
      it_configures 'rabbit with HA support'
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

  end

  shared_examples_for 'a designate base installation' do

    it { is_expected.to contain_class('designate::deps') }
    it { is_expected.to contain_class('designate::logging') }
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

    it 'configures debug and verbosity' do
      is_expected.to contain_designate_config('DEFAULT/root_helper').with_value( params[:root_helper] )
    end

    it 'configures notification' do
      is_expected.to contain_designate_config('oslo_messaging_notifications/driver').with_value('messaging' )
      is_expected.to contain_designate_config('oslo_messaging_notifications/topics').with_value('notifications')
      is_expected.to contain_designate_config('oslo_messaging_notifications/transport_url').with_value('<SERVICE DEFAULT>')
      is_expected.to contain_designate_config('DEFAULT/transport_url').with_value('<SERVICE DEFAULT>')
      is_expected.to contain_designate_config('DEFAULT/rpc_response_timeout').with_value('<SERVICE DEFAULT>')
      is_expected.to contain_designate_config('DEFAULT/control_exchange').with_value('<SERVICE DEFAULT>')
    end

  end

  shared_examples_for 'rabbit without HA support' do
    before { params.merge!( rabbit_non_ha_params ) }

    it 'configures rabbit' do
      is_expected.to contain_designate_config('oslo_messaging_rabbit/rabbit_userid').with_value( params[:rabbit_userid] )
      is_expected.to contain_designate_config('oslo_messaging_rabbit/rabbit_password').with_value( params[:rabbit_password] )
      is_expected.to contain_designate_config('oslo_messaging_rabbit/rabbit_password').with_value( params[:rabbit_password] ).with_secret(true)
      is_expected.to contain_designate_config('oslo_messaging_rabbit/rabbit_virtual_host').with_value( params[:rabbit_virtual_host] )
    end

    it { is_expected.to contain_designate_config('oslo_messaging_rabbit/rabbit_host').with_value( params[:rabbit_host] ) }
    it { is_expected.to contain_designate_config('oslo_messaging_rabbit/rabbit_hosts').with_value('<SERVICE DEFAULT>') }
    it { is_expected.to contain_designate_config('oslo_messaging_rabbit/rabbit_port').with_value( params[:rabbit_port] ) }
    it { is_expected.to contain_designate_config('oslo_messaging_rabbit/rabbit_ha_queues').with_value( 'false' ) }

  end

  shared_examples_for 'rabbit with HA support' do
    before { params.merge!( rabbit_ha_params ) }

    it 'configures rabbit' do
      is_expected.to contain_designate_config('oslo_messaging_rabbit/rabbit_userid').with_value( params[:rabbit_userid] )
      is_expected.to contain_designate_config('oslo_messaging_rabbit/rabbit_password').with_value( params[:rabbit_password] )
      is_expected.to contain_designate_config('oslo_messaging_rabbit/rabbit_password').with_value( params[:rabbit_password] ).with_secret(true)
      is_expected.to contain_designate_config('oslo_messaging_rabbit/rabbit_virtual_host').with_value( params[:rabbit_virtual_host] )
    end

    it { is_expected.to contain_designate_config('oslo_messaging_rabbit/rabbit_host').with_value('<SERVICE DEFAULT>') }
    it { is_expected.to contain_designate_config('oslo_messaging_rabbit/rabbit_hosts').with_value( '10.0.0.1:5672,10.0.0.2:5672,10.0.0.3:5672' ) }
    it { is_expected.to contain_designate_config('oslo_messaging_rabbit/rabbit_port').with_value('<SERVICE DEFAULT>') }
    it { is_expected.to contain_designate_config('oslo_messaging_rabbit/rabbit_ha_queues').with_value( 'true' ) }

  end

  shared_examples_for 'rabbit with SSL support' do
    before { params.merge!( rabbit_use_ssl ) }

    it 'configures rabbit with ssl' do
      is_expected.to contain_designate_config('oslo_messaging_rabbit/rabbit_userid').with_value( params[:rabbit_userid] )
      is_expected.to contain_designate_config('oslo_messaging_rabbit/rabbit_password').with_value( params[:rabbit_password] )
      is_expected.to contain_designate_config('oslo_messaging_rabbit/rabbit_password').with_value( params[:rabbit_password] ).with_secret(true)
      is_expected.to contain_designate_config('oslo_messaging_rabbit/rabbit_virtual_host').with_value( params[:rabbit_virtual_host] )
      is_expected.to contain_designate_config('oslo_messaging_rabbit/rabbit_use_ssl').with_value( params[:rabbit_use_ssl] )
      is_expected.to contain_designate_config('oslo_messaging_rabbit/kombu_ssl_ca_certs').with_value( params[:kombu_ssl_ca_certs] )
      is_expected.to contain_designate_config('oslo_messaging_rabbit/kombu_ssl_certfile').with_value( params[:kombu_ssl_certfile] )
      is_expected.to contain_designate_config('oslo_messaging_rabbit/kombu_ssl_keyfile').with_value( params[:kombu_ssl_keyfile] )
      is_expected.to contain_designate_config('oslo_messaging_rabbit/kombu_ssl_version').with_value( params[:kombu_ssl_version] )
      is_expected.to contain_designate_config('oslo_messaging_rabbit/kombu_reconnect_delay').with_value( params[:kombu_reconnect_delay] )
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

  shared_examples_for 'rabbit with deprecated option' do
    before { params.merge!( rabbit_deprecated_params ) }

    it 'configures rabbit' do
      is_expected.to contain_designate_config('oslo_messaging_rabbit/rabbit_virtual_host').with_value( params[:rabbit_virtualhost] )
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
