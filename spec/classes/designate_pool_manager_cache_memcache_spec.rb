#
# Unit tests for designate::pool_manager
#
require 'spec_helper'

describe 'designate::pool_manager_cache::memcache' do
  let :params do
    {
    }
  end

  shared_examples 'designate-pool-manager-cache-memcache' do
    context 'with default parameters' do
      it { is_expected.to contain_class('designate::pool_manager_cache::memcache') }
      it 'configures designate-pool-manager with required parameters' do
        is_expected.to contain_designate_config('service:pool_manager/cache_driver').with_value('memcache')
        is_expected.to contain_designate_config('pool_manager_cache:memcache/memcached_servers').with_value(['127.0.0.1'])
        is_expected.to contain_designate_config('pool_manager_cache:memcache/expiration').with_value('<SERVICE DEFAULT>')
      end
    end

    context 'with all parameters' do
      before do
        params.merge!( { :memcached_servers => ['192.168.0.1'], :expiration => 123  } )
      end

      it { is_expected.to contain_class('designate::pool_manager_cache::memcache') }
      it 'configures designate-pool-manager with required parameters' do
        is_expected.to contain_designate_config('service:pool_manager/cache_driver').with_value('memcache')
        is_expected.to contain_designate_config('pool_manager_cache:memcache/memcached_servers').with_value( params[:memcached_servers] )
        is_expected.to contain_designate_config('pool_manager_cache:memcache/expiration').with_value( params[:expiration] )
      end
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
          {
            :pool_manager_package_name => 'designate-pool-manager',
            :pool_manager_service_name => 'designate-pool-manager'
          }
        when 'RedHat'
          {
            :pool_manager_package_name => 'openstack-designate-pool-manager',
            :pool_manager_service_name => 'openstack-designate-pool-manager'
          }
        end
      end
      it_behaves_like 'designate-pool-manager-cache-memcache'
    end
  end
end
