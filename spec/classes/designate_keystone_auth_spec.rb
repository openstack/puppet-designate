#
# Unit tests for designate::keystone::auth
#

require 'spec_helper'

describe 'designate::keystone::auth' do
  shared_examples_for 'designate::keystone::auth' do
    context 'with default class parameters' do
      let :params do
        { :password => 'designate_password' }
      end

      it { is_expected.to contain_keystone__resource__service_identity('designate').with(
        :configure_user      => true,
        :configure_user_role => true,
        :configure_endpoint  => true,
        :service_name        => 'designate',
        :service_type        => 'dns',
        :service_description => 'OpenStack DNSaas Service',
        :region              => 'RegionOne',
        :auth_name           => 'designate',
        :password            => 'designate_password',
        :email               => 'designate@localhost',
        :tenant              => 'services',
        :roles               => ['admin'],
        :system_scope        => 'all',
        :system_roles        => [],
        :public_url          => 'http://127.0.0.1:9001',
        :internal_url        => 'http://127.0.0.1:9001',
        :admin_url           => 'http://127.0.0.1:9001',
      ) }
    end

    context 'when overriding parameters' do
      let :params do
        { :password            => 'designate_password',
          :auth_name           => 'alt_designate',
          :email               => 'alt_designate@alt_localhost',
          :tenant              => 'alt_service',
          :roles               => ['admin', 'service'],
          :system_scope        => 'alt_all',
          :system_roles        => ['admin', 'member', 'reader'],
          :configure_endpoint  => false,
          :configure_user      => false,
          :configure_user_role => false,
          :service_description => 'Alternative OpenStack DNSaas Service',
          :service_name        => 'alt_service',
          :service_type        => 'alt_dns',
          :region              => 'RegionTwo',
          :public_url          => 'https://10.10.10.10:80',
          :internal_url        => 'http://10.10.10.11:81',
          :admin_url           => 'http://10.10.10.12:81' }
      end

      it { is_expected.to contain_keystone__resource__service_identity('designate').with(
        :configure_user      => false,
        :configure_user_role => false,
        :configure_endpoint  => false,
        :service_name        => 'alt_service',
        :service_type        => 'alt_dns',
        :service_description => 'Alternative OpenStack DNSaas Service',
        :region              => 'RegionTwo',
        :auth_name           => 'alt_designate',
        :password            => 'designate_password',
        :email               => 'alt_designate@alt_localhost',
        :tenant              => 'alt_service',
        :roles               => ['admin', 'service'],
        :system_scope        => 'alt_all',
        :system_roles        => ['admin', 'member', 'reader'],
        :public_url          => 'https://10.10.10.10:80',
        :internal_url        => 'http://10.10.10.11:81',
        :admin_url           => 'http://10.10.10.12:81',
      ) }
    end
  end

  on_supported_os({
    :supported_os => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts())
      end

      it_behaves_like 'designate::keystone::auth'
    end
  end
end
