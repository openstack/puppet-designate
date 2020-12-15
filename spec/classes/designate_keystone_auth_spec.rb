#
# Unit tests for designate::keystone::auth
#
require 'spec_helper'

describe 'designate::keystone::auth' do
  shared_examples_for 'designate-keystone-auth' do
    context 'with default class parameters' do
      let :params do
        { :password => 'desigpwd',
          :tenant   => 'fooboozoo' }
      end

      it { is_expected.to contain_keystone_user('designate').with(
        :ensure   => 'present',
        :password => 'desigpwd',
      ) }

      it { is_expected.to contain_keystone_user_role('designate@fooboozoo').with(
        :ensure  => 'present',
        :roles   => ['admin']
      )}

      it { is_expected.to contain_keystone_service('designate::dns').with(
        :ensure      => 'present',
        :description => 'Openstack DNSaas Service'
      ) }

      it { is_expected.to contain_keystone_endpoint('RegionOne/designate::dns').with(
        :ensure       => 'present',
        :public_url   => "http://127.0.0.1:9001",
        :admin_url    => "http://127.0.0.1:9001",
        :internal_url => "http://127.0.0.1:9001"
      ) }
    end


    context 'when overriding endpoint URLs' do
      let :params do
        { :password         => 'desigpwd',
          :public_url       => 'https://10.10.10.10:81/v2',
          :internal_url     => 'https://10.10.10.11:81/v2',
          :admin_url        => 'https://10.10.10.12:81/v2' }
      end

      it { is_expected.to contain_keystone_endpoint('RegionOne/designate::dns').with(
        :ensure       => 'present',
        :public_url   => 'https://10.10.10.10:81/v2',
        :internal_url => 'https://10.10.10.11:81/v2',
        :admin_url    => 'https://10.10.10.12:81/v2'
      ) }
    end

    context 'when overriding auth and service name' do
      let :params do
        { :password => 'foo',
          :service_name => 'designatey',
          :auth_name => 'designatey' }
      end

      it { is_expected.to contain_keystone_user('designatey') }
      it { is_expected.to contain_keystone_user_role('designatey@services') }
      it { is_expected.to contain_keystone_service('designatey::dns') }
      it { is_expected.to contain_keystone_endpoint('RegionOne/designatey::dns') }
    end

  end

  describe 'when disabling user and user_role configuration' do
    let :params do
      { :configure_user      => false,
        :configure_user_role => false,
        :service_name => 'designate',
        :auth_name => 'designate',
        :password            => 'designate_password' }
    end
    it { is_expected.to_not contain_keystone_user('designate') }
    it { is_expected.to_not contain_keystone_user_role('designate@services') }
    it { is_expected.to contain_keystone_service('designate::dns') }
    it { is_expected.to contain_keystone_endpoint('RegionOne/designate::dns') }
  end

  on_supported_os({
    :supported_os => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts())
      end

      it_behaves_like 'designate-keystone-auth'
    end
  end
end
