#
# Unit tests for designate::pool_manager_cache::sqlalchemy
#
require 'spec_helper'

describe 'designate::pool_manager_cache::sqlalchemy' do
  let :params do
    {
    }
  end

  let :params_all do
    {
      :connection         => 'connection = sqlite:///$state_path/designate_pool_manager.sqlite',
      :connection_debug   => 100,
      :connection_trace   => true,
      :sqlite_synchronous => true,
      :idle_timeout       => 3600,
      :max_retries        => 10,
      :retry_interval     => 10,
    }
  end

  shared_examples 'designate-pool-manager-cache-sqlalchemy' do
    context 'with default parameters' do
      it { is_expected.to contain_class('designate::pool_manager_cache::sqlalchemy') }

      it 'configures designate-pool-manager with required parameters' do
        is_expected.to contain_designate_config('service:pool_manager/cache_driver').with_value('sqlalchemy')
        is_expected.to contain_designate_config('pool_manager_cache:sqlalchemy/connection').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_designate_config('pool_manager_cache:sqlalchemy/connection_debug').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_designate_config('pool_manager_cache:sqlalchemy/connection_trace').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_designate_config('pool_manager_cache:sqlalchemy/sqlite_synchronous').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_designate_config('pool_manager_cache:sqlalchemy/idle_timeout').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_designate_config('pool_manager_cache:sqlalchemy/max_retries').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_designate_config('pool_manager_cache:sqlalchemy/retry_interval').with_value('<SERVICE DEFAULT>')
      end
    end

    context 'with all parameters' do
      before do
        params.merge!( params_all )
      end

      it 'configures designate-pool-manager with required parameters' do
        is_expected.to contain_designate_config('pool_manager_cache:sqlalchemy/connection').with_value( params[:connection] )
        is_expected.to contain_designate_config('pool_manager_cache:sqlalchemy/connection_debug').with_value( params[:connection_debug] )
        is_expected.to contain_designate_config('pool_manager_cache:sqlalchemy/connection_trace').with_value( params[:connection_trace] )
        is_expected.to contain_designate_config('pool_manager_cache:sqlalchemy/sqlite_synchronous').with_value( params[:sqlite_synchronous] )
        is_expected.to contain_designate_config('pool_manager_cache:sqlalchemy/idle_timeout').with_value( params[:idle_timeout] )
        is_expected.to contain_designate_config('pool_manager_cache:sqlalchemy/max_retries').with_value( params[:max_retries] )
        is_expected.to contain_designate_config('pool_manager_cache:sqlalchemy/retry_interval').with_value( params[:retry_interval] )
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

      it_behaves_like 'designate-pool-manager-cache-sqlalchemy'
    end
  end
end
