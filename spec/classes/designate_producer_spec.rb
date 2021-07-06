#
# Unit tests for designate::producer
#
require 'spec_helper'


describe 'designate::producer' do
  let :params do
    {
    }
  end
  let :designate_producer_params do
    {
      :workers            => '3',
      :threads            => '3000',
      :enabled_tasks      => ['domain_purge','periodic_secondary_refresh'],
      :backend_url        => 'redis://10.0.0.1:1234'
    }
  end


  shared_examples 'designate-producer' do
    context 'with default parameters' do
      it 'installs designate-producer package and service' do
        is_expected.to contain_package('designate-producer').with(
          :name   => platform_params[:producer_package_name],
          :ensure => 'present',
          :tag    => ['openstack','designate-package'],
        )
        is_expected.to contain_service('designate-producer').with(
          :name  => 'designate-producer',
          :ensure => 'running',
          :tag    => ['openstack','designate-service'],
        )
      end

      it 'configures designate producer with default config options' do
        is_expected.to contain_designate_config("service:producer/workers").with(:value => 8)
        is_expected.to contain_designate_config("service:producer/threads").with(:value => '<SERVICE DEFAULT>')
        is_expected.to contain_designate_config("service:producer/enabled_tasks").with(:value => '<SERVICE DEFAULT>')
      end
    end

    context 'with non default parameters' do
      before { params.merge!( designate_producer_params ) }
      it 'configures desginate produce with non default parameters' do
        is_expected.to contain_designate_config("service:producer/workers").with(:value => '3')
        is_expected.to contain_designate_config("service:producer/threads").with(:value => '3000')
        is_expected.to contain_designate_config("service:producer/enabled_tasks").with(:value => ['domain_purge','periodic_secondary_refresh'])
        is_expected.to contain_designate_config("coordination/backend_url").with(:value => 'redis://10.0.0.1:1234')
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
          { :producer_package_name => 'designate-producer' }
        when 'RedHat'
          { :producer_package_name => 'openstack-designate-producer' }
        end
      end
      it_configures 'designate-producer'
    end
  end
end
