#
# Unit tests for designate::pool_manager
#
require 'spec_helper'

describe 'designate::pool_manager' do
  let :params do
    {
      :pool_id => '794ccc2c-d751-44fe-b57f-8894c9f5c842',
    }
  end

  let :params_all do
    {
      :manage_package               => true,
      :package_ensure               => 'present',
      :pool_manager_package_name    => nil,
      :enabled                      => true,
      :service_ensure               => 'running',
      :workers                      => 10,
      :threads                      => 900,
      :threshold_percentage         => 90,
      :poll_timeout                 => 15,
      :poll_retry_interval          => 10,
      :poll_max_retries             => 5,
      :poll_delay                   => 1,
      :enable_recovery_timer        => false,
      :periodic_recovery_interval   => 60,
      :enable_sync_timer            => false,
      :periodic_sync_interval       => 900,
      :periodic_sync_seconds        => 5,
      :periodic_sync_max_attempts   => 1,
      :periodic_sync_retry_interval => 15,
    }
  end

  shared_examples 'designate-pool-manager' do
    context 'with default parameters' do
      it { is_expected.to contain_class('designate::pool_manager') }

      it 'installs designate-pool-manager package and service' do
        is_expected.to contain_service('designate-pool-manager').with(
          :name      => platform_params[:pool_manager_service_name],
          :ensure    => 'running',
          :enable    => 'true',
          :tag       => ['openstack', 'designate-service'],
        )
        is_expected.to contain_package('designate-pool-manager').with(
          :name      => platform_params[:pool_manager_package_name],
          :ensure    => 'present',
          :tag       => ['openstack', 'designate-package'],
        )
      end

      it 'configures designate-pool-manager with default parameters' do
        is_expected.to contain_designate_config('service:pool_manager/pool_id').with_value( params[:pool_id] )
        is_expected.to contain_designate_config('service:pool_manager/workers').with_value( '<SERVICE DEFAULT>' )
        is_expected.to contain_designate_config('service:pool_manager/threads').with_value( '<SERVICE DEFAULT>' )
        is_expected.to contain_designate_config('service:pool_manager/threshold_percentage').with_value( '<SERVICE DEFAULT>' )
        is_expected.to contain_designate_config('service:pool_manager/poll_timeout').with_value( '<SERVICE DEFAULT>' )
        is_expected.to contain_designate_config('service:pool_manager/poll_retry_interval').with_value( '<SERVICE DEFAULT>' )
        is_expected.to contain_designate_config('service:pool_manager/poll_max_retries').with_value( '<SERVICE DEFAULT>' )
        is_expected.to contain_designate_config('service:pool_manager/poll_delay').with_value( '<SERVICE DEFAULT>' )
        is_expected.to contain_designate_config('service:pool_manager/enable_recovery_timer').with_value( '<SERVICE DEFAULT>' )
        is_expected.to contain_designate_config('service:pool_manager/periodic_recovery_interval').with_value( '<SERVICE DEFAULT>' )
        is_expected.to contain_designate_config('service:pool_manager/enable_sync_timer').with_value( '<SERVICE DEFAULT>' )
        is_expected.to contain_designate_config('service:pool_manager/periodic_sync_interval').with_value( '<SERVICE DEFAULT>' )
        is_expected.to contain_designate_config('service:pool_manager/periodic_sync_seconds').with_value( '<SERVICE DEFAULT>' )
        is_expected.to contain_designate_config('service:pool_manager/periodic_sync_max_attempts').with_value( '<SERVICE DEFAULT>' )
        is_expected.to contain_designate_config('service:pool_manager/periodic_sync_retry_interval').with_value( '<SERVICE DEFAULT>' )
      end
    end

    context 'with custom package name' do
      before do
        params.merge!({ :pool_manager_package_name => 'designate-pool-manager-custom-name' })
      end

      it 'configures using custom name' do
        is_expected.to contain_package('designate-pool-manager').with(
          :name      => 'designate-pool-manager-custom-name',
          :ensure    => 'present',
          :tag       => ['openstack', 'designate-package'],
        )
      end
    end

    context 'with all params' do
      before do
        params.merge!( params_all )
      end

      it 'configures designate-pool-manager with all parameters' do
        is_expected.to contain_designate_config('service:pool_manager/pool_id').with_value( params[:pool_id] )
        is_expected.to contain_designate_config('service:pool_manager/workers').with_value( params[:workers] )
        is_expected.to contain_designate_config('service:pool_manager/threads').with_value( params[:threads] )
        is_expected.to contain_designate_config('service:pool_manager/threshold_percentage').with_value( params[:threshold_percentage] )
        is_expected.to contain_designate_config('service:pool_manager/poll_timeout').with_value( params[:poll_timeout] )
        is_expected.to contain_designate_config('service:pool_manager/poll_retry_interval').with_value( params[:poll_retry_interval] )
        is_expected.to contain_designate_config('service:pool_manager/poll_max_retries').with_value( params[:poll_max_retries] )
        is_expected.to contain_designate_config('service:pool_manager/poll_delay').with_value( params[:poll_delay] )
        is_expected.to contain_designate_config('service:pool_manager/enable_recovery_timer').with_value( params[:enable_recovery_timer] )
        is_expected.to contain_designate_config('service:pool_manager/periodic_recovery_interval').with_value( params[:periodic_recovery_interval] )
        is_expected.to contain_designate_config('service:pool_manager/enable_sync_timer').with_value( params[:enable_sync_timer] )
        is_expected.to contain_designate_config('service:pool_manager/periodic_sync_interval').with_value( params[:periodic_sync_interval] )
        is_expected.to contain_designate_config('service:pool_manager/periodic_sync_seconds').with_value( params[:periodic_sync_seconds] )
        is_expected.to contain_designate_config('service:pool_manager/periodic_sync_max_attempts').with_value( params[:periodic_sync_max_attempts] )
        is_expected.to contain_designate_config('service:pool_manager/periodic_sync_retry_interval').with_value( params[:periodic_sync_retry_interval] )
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
      it_behaves_like 'designate-pool-manager'
    end
  end
end
