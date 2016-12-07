#
# Unit tests for designate::zone_manager
#
require 'spec_helper'


describe 'designate::zone_manager' do
  let :params do
    {
    }
  end
  let :designate_zone_manager_params do
    {
      :workers            => '3',
      :threads            => '3000',
      :enabled_tasks      => ['domain_purge','periodic_secondary_refresh'],
      :export_synchronous => 'False',
    }
  end


  shared_examples 'designate-zone-manager' do
    context 'with default parameters' do
      it 'installs designate-zone-manager package and service' do
        is_expected.to contain_package('designate-zone-manager').with(
          :name   => platform_params[:zone_manager_package_name],
          :ensure => 'present',
          :tag    => ['openstack','designate-package'],
        )
        is_expected.to contain_service('designate-zone-manager').with(
          :name  => 'designate-zone-manager',
          :ensure => 'running',
          :tag    => ['openstack','designate-service'],
        )
      end

      it 'configures designate zone manager with default config options' do
        is_expected.to contain_designate_config("service:zone_manager/workers").with(:value => 8)
        is_expected.to contain_designate_config("service:zone_manager/threads").with(:value => '<SERVICE DEFAULT>')
        is_expected.to contain_designate_config("service:zone_manager/enabled_tasks").with(:value => '<SERVICE DEFAULT>')
        is_expected.to contain_designate_config("service:zone_manager/export_synchronous").with(:value => '<SERVICE DEFAULT>')
      end
    end

    context 'with non default parameters' do
      before { params.merge!( designate_zone_manager_params ) }
      it 'configures desginate zone manager with non default parameters' do
        is_expected.to contain_designate_config("service:zone_manager/workers").with(:value => '3')
        is_expected.to contain_designate_config("service:zone_manager/threads").with(:value => '3000')
        is_expected.to contain_designate_config("service:zone_manager/enabled_tasks").with(:value => ['domain_purge','periodic_secondary_refresh'])
        is_expected.to contain_designate_config("service:zone_manager/export_synchronous").with(:value => 'False')
      end
    end
  end

  on_supported_os({
    :supported_os   => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts({ :os_workers => 8 }))
      end

      let(:platform_params) do
        case facts[:osfamily]
        when 'Debian'
          { :zone_manager_package_name => 'designate-zone-manager' }
        when 'RedHat'
          { :zone_manager_package_name => 'openstack-designate-zone-manager' }
        end
      end
      it_configures 'designate-zone-manager'
    end
  end
end
