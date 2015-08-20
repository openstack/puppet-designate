#
# Unit tests for designate::api
#
require 'spec_helper'

describe 'designate::api' do
  let :params do
    {
      :keystone_password => 'passw0rd',
      :keystone_host     => '10.0.0.42',
      :keystone_port     => '35357',
      :keystone_protocol => 'https',
      :keystone_tenant   => '_services_',
      :keystone_user     => 'designate',
    }
  end

  shared_examples 'designate-api' do
    context 'with default parameters' do
      it 'installs designate-api package and service' do
        is_expected.to contain_service('designate-api').with(
          :name      => platform_params[:api_service_name],
          :ensure    => 'running',
          :enable    => 'true',
          :tag       => ['openstack', 'designate-service'],
        )
        is_expected.to contain_package('designate-api').with(
          :name      => platform_params[:api_package_name],
          :ensure    => 'present',
          :tag       => ['openstack', 'designate-package'],
        )
      end

      it 'configures designate-api with default parameters' do
        is_expected.to contain_designate_config('service:api/auth_strategy').with_value('noauth')
        is_expected.to contain_designate_config('service:api/enable_api_v1').with_value(true)

        is_expected.to contain_designate_config('keystone_authtoken/auth_host').with_value('10.0.0.42')
        is_expected.to contain_designate_config('keystone_authtoken/auth_port').with_value('35357')
        is_expected.to contain_designate_config('keystone_authtoken/auth_protocol').with_value('https')
        is_expected.to contain_designate_config('keystone_authtoken/admin_tenant_name').with_value('_services_')
        is_expected.to contain_designate_config('keystone_authtoken/admin_user').with_value('designate')
        is_expected.to contain_designate_config('keystone_authtoken/admin_password').with_value('passw0rd')

      end

      context 'when using auth against keystone' do
        before { params.merge!(:auth_strategy => 'keystone') }
        it 'configures designate-api with keystone auth strategy' do
          is_expected.to contain_designate_config('service:api/auth_strategy').with_value('keystone')
        end
      end
    end
  end

  context 'on Debian platforms' do
    let :facts do
      { :osfamily => 'Debian' }
    end

    let :platform_params do
      {
        :api_package_name => 'designate-api',
        :api_service_name => 'designate-api'
      }
    end

    it_configures 'designate-api'
  end

  context 'on RedHat platforms' do
    let :facts do
      { :osfamily => 'RedHat' }
    end

    let :platform_params do
      {
        :api_package_name => 'openstack-designate-api',
        :api_service_name => 'openstack-designate-api'
      }
    end

    it_configures 'designate-api'
  end

  context 'with custom package name' do
    let :facts do
      { :osfamily => 'RedHat' }
    end

    let :platform_params do
      { :api_package_name => 'designate-api-custom-name',
        :api_service_name => 'openstack-designate-api'
      }
    end

    before do
      params.merge!({ :api_package_name => 'designate-api-custom-name' })
    end

    it_configures 'designate-api'
  end
end
