#
# Unit tests for designate::central
#
require 'spec_helper'

describe 'designate::central' do
  let :params do
    {
      :enabled => true
    }
  end

  shared_examples 'designate-central' do
    context 'with default parameters' do
      it 'installs designate-central package and service' do
        is_expected.to contain_service('designate-central').with(
          :name      => platform_params[:central_service_name],
          :ensure    => 'running',
          :enable    => 'true',
          :tag       => ['openstack', 'designate-service'],
        )
        is_expected.to contain_package('designate-central').with(
          :name      => platform_params[:central_package_name],
          :ensure    => 'present',
          :tag       => ['openstack', 'designate-package'],
        )
      end

      it 'includes designate::db' do
        is_expected.to contain_class('designate::db')
      end

      it 'configures designate-central with default parameters' do
        is_expected.to contain_designate_config('service:central/managed_resource_email').with_value('hostmaster@example.com')
        is_expected.to contain_designate_config('service:central/managed_resource_tenant_id').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_designate_config('service:central/max_zone_name_len').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_designate_config('service:central/max_recordset_name_len').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_designate_config('service:central/min_ttl').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_designate_config('service:central/workers').with_value(8)
        is_expected.to contain_designate_config('service:central/threads').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_designate_config('service:central/default_pool_id').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_designate_config('service:central/scheduler_filters').with_value('<SERVICE DEFAULT>')
      end
    end

    context 'with parameters overridden' do
      before do
        params.merge!({
          :max_zone_name_len      => 100,
          :max_recordset_name_len => 200,
          :scheduler_filters      => 'default_pool',
        })
      end

      it 'configures the values set' do
        is_expected.to contain_designate_config('service:central/max_zone_name_len').with_value(100)
        is_expected.to contain_designate_config('service:central/max_recordset_name_len').with_value(200)
        is_expected.to contain_designate_config('service:central/scheduler_filters').with_value('default_pool')
      end
    end

    context 'with custom package name' do
      before do
        params.merge!({ :central_package_name => 'designate-central-custom-name' })
      end

      it 'configures using custom name' do
        is_expected.to contain_package('designate-central').with(
          :name      => 'designate-central-custom-name',
          :ensure    => 'present',
          :tag       => ['openstack', 'designate-package'],
        )
      end
    end
  end

  on_supported_os({
    :supported_os => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts({ :os_workers => 8 }))
      end

      let(:platform_params) do
        case facts[:os]['family']
        when 'Debian'
          {
            :central_package_name => 'designate-central',
            :central_service_name => 'designate-central'
          }
        when 'RedHat'
          {
            :central_package_name => 'openstack-designate-central',
            :central_service_name => 'designate-central'
          }
        end
      end
      it_behaves_like 'designate-central'
    end
  end

end
