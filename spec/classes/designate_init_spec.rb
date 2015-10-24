#
# Unit tests for designate::init
#
require 'spec_helper'

describe 'designate' do

  let :params do
    {
      :package_ensure     => 'installed',
      :debug              => 'False',
      :verbose            => 'False',
      :root_helper        => 'sudo designate-rootwrap /etc/designate/rootwrap.conf'
    }
  end

  let :rabbit_ha_params do
    {
      :rabbit_hosts       => [ '10.0.0.1:5672', '10.0.0.2:5672', '10.0.0.3:5672' ],
      :rabbit_userid      => 'guest',
      :rabbit_password    => '',
      :rabbit_virtualhost => '/'
    }
  end

  let :rabbit_non_ha_params do
    {
      :rabbit_host        => '127.0.0.1',
      :rabbit_port        => 5672,
      :rabbit_userid      => 'guest',
      :rabbit_password    => '',
      :rabbit_virtualhost => '/'
    }
  end

  shared_examples_for 'designate' do

    context 'with rabbit_host parameter' do
      it_configures 'a designate base installation'
      it_configures 'rabbit without HA support'
      it_configures 'rabbit with HA support'
    end

  end

  shared_examples_for 'a designate base installation' do

    it { is_expected.to contain_class('designate::logging') }
    it { is_expected.to contain_class('designate::params') }

    it 'configures designate group' do
      is_expected.to contain_group('designate').with(
        :ensure  => 'present',
        :name    => 'designate',
        :before  => 'Anchor[designate::install::end]',
      )
    end

    it 'configures designate user' do
      is_expected.to contain_user('designate').with(
        :ensure  => 'present',
        :name    => 'designate',
        :gid     => 'designate',
        :system  => true,
        :before  => 'Anchor[designate::install::end]',
      )
    end

    it 'configures designate configuration folder' do
      is_expected.to contain_file('/etc/designate/').with(
        :ensure  => 'directory',
        :owner   => 'designate',
        :group   => 'designate',
        :mode    => '0750'
      )
    end

    it 'installs designate common package' do
      is_expected.to contain_package('designate-common').with(
        :ensure => 'installed',
        :name   => platform_params[:common_package_name],
        :tag    => ['openstack', 'designate-package'],
        :before  => ['User[designate]', 'Group[designate]'],
      )
    end

    it 'configures debug and verbosity' do
      is_expected.to contain_designate_config('DEFAULT/root_helper').with_value( params[:root_helper] )
    end

    it 'configures notification' do
      is_expected.to contain_designate_config('DEFAULT/notification_driver').with_value('messaging' )
      is_expected.to contain_designate_config('DEFAULT/notification_topics').with_value('notifications')
    end

    it 'configures phase anchors' do
      is_expected.to contain_anchor('designate::install::begin')
      is_expected.to contain_anchor('designate::install::end').with(
        :notify => ['Anchor[designate::service::begin]'],
      )
      is_expected.to contain_anchor('designate::config::begin')
      is_expected.to contain_anchor('designate::config::end').with(
        :notify => ['Anchor[designate::service::begin]'],
      )
      is_expected.to contain_anchor('designate::service::begin')
      is_expected.to contain_anchor('designate::service::end')
    end

  end

  shared_examples_for 'rabbit without HA support' do
    before { params.merge!( rabbit_non_ha_params ) }

    it 'configures rabbit' do
      is_expected.to contain_designate_config('oslo_messaging_rabbit/rabbit_userid').with_value( params[:rabbit_userid] )
      is_expected.to contain_designate_config('oslo_messaging_rabbit/rabbit_password').with_value( params[:rabbit_password] )
      is_expected.to contain_designate_config('oslo_messaging_rabbit/rabbit_password').with_value( params[:rabbit_password] ).with_secret(true)
      is_expected.to contain_designate_config('oslo_messaging_rabbit/rabbit_virtualhost').with_value( params[:rabbit_virtualhost] )
    end

    it { is_expected.to contain_designate_config('oslo_messaging_rabbit/rabbit_host').with_value( params[:rabbit_host] ) }
    it { is_expected.to contain_designate_config('oslo_messaging_rabbit/rabbit_hosts').with_value( "#{params[:rabbit_host]}:#{params[:rabbit_port]}" ) }
    it { is_expected.to contain_designate_config('oslo_messaging_rabbit/rabbit_port').with_value( params[:rabbit_port] ) }
    it { is_expected.to contain_designate_config('oslo_messaging_rabbit/rabbit_ha_queues').with_value( 'false' ) }

  end

  shared_examples_for 'rabbit with HA support' do
    before { params.merge!( rabbit_ha_params ) }

    it 'configures rabbit' do
      is_expected.to contain_designate_config('oslo_messaging_rabbit/rabbit_userid').with_value( params[:rabbit_userid] )
      is_expected.to contain_designate_config('oslo_messaging_rabbit/rabbit_password').with_value( params[:rabbit_password] )
      is_expected.to contain_designate_config('oslo_messaging_rabbit/rabbit_password').with_value( params[:rabbit_password] ).with_secret(true)
      is_expected.to contain_designate_config('oslo_messaging_rabbit/rabbit_virtualhost').with_value( params[:rabbit_virtualhost] )
    end

    it { is_expected.to contain_designate_config('oslo_messaging_rabbit/rabbit_host').with_ensure( 'absent' ) }
    it { is_expected.to contain_designate_config('oslo_messaging_rabbit/rabbit_hosts').with_value( '10.0.0.1:5672,10.0.0.2:5672,10.0.0.3:5672' ) }
    it { is_expected.to contain_designate_config('oslo_messaging_rabbit/rabbit_port').with_ensure( 'absent' ) }
    it { is_expected.to contain_designate_config('oslo_messaging_rabbit/rabbit_ha_queues').with_value( 'true' ) }

  end

  context 'on Debian platforms' do
    let :facts do
      { :osfamily => 'Debian' }
    end

    let :platform_params do
      { :common_package_name => 'designate-common' }
    end

    it_configures 'designate'
  end

  context 'on RedHat platforms' do
    let :facts do
      { :osfamily => 'RedHat' }
    end

    let :platform_params do
      { :common_package_name => 'openstack-designate' }
    end

    it_configures 'designate'
  end

  context 'with custom package name' do
    let :facts do
      { :osfamily => 'RedHat' }
    end

    let :platform_params do
      { :common_package_name => 'designate-common-custom-name' }
    end

    before do
      params.merge!({ :common_package_name => 'designate-common-custom-name' })
    end

    it_configures 'designate'
  end
end
