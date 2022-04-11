#
# Unit tests for designate::worker
#
require 'spec_helper'

describe 'designate::worker' do
  let :params do
    {
    }
  end

  let :params_all do
    {
      :package_ensure       => 'present',
      :enabled              => true,
      :manage_service       => true,
      :workers              => 10,
      :threads              => 900,
      :threshold_percentage => 90,
      :poll_timeout         => 15,
      :poll_retry_interval  => 10,
      :poll_max_retries     => 5,
      :poll_delay           => 1,
      :worker_notify        => true,
      :export_synchronous   => true,
      :topic                => 'topic',
    }
  end

  shared_examples 'designate-worker' do
    context 'with default parameters' do
      it { is_expected.to contain_class('designate::worker') }

      it 'installs designate-worker package and service' do
        is_expected.to contain_service('designate-worker').with(
          :name      => platform_params[:worker_service_name],
          :ensure    => 'running',
          :enable    => 'true',
          :tag       => ['openstack', 'designate-service'],
        )
        is_expected.to contain_package('designate-worker').with(
          :name      => platform_params[:worker_package_name],
          :ensure    => 'present',
          :tag       => ['openstack', 'designate-package'],
        )
      end

      it 'configures designate-worker with default parameters' do
        is_expected.to contain_designate_config('service:worker/workers').with_value(8)
        is_expected.to contain_designate_config('service:worker/threads').with_value( '<SERVICE DEFAULT>' )
        is_expected.to contain_designate_config('service:worker/threshold_percentage').with_value( '<SERVICE DEFAULT>' )
        is_expected.to contain_designate_config('service:worker/poll_timeout').with_value( '<SERVICE DEFAULT>' )
        is_expected.to contain_designate_config('service:worker/poll_retry_interval').with_value( '<SERVICE DEFAULT>' )
        is_expected.to contain_designate_config('service:worker/poll_max_retries').with_value( '<SERVICE DEFAULT>' )
        is_expected.to contain_designate_config('service:worker/poll_delay').with_value( '<SERVICE DEFAULT>' )
        is_expected.to contain_designate_config('service:worker/export_synchronous').with_value( '<SERVICE DEFAULT>' )
        is_expected.to contain_designate_config('service:worker/topic').with_value( '<SERVICE DEFAULT>' )
      end
    end

    context 'with custom package name' do
      before do
        params.merge!({ :worker_package_name => 'designate-worker-custom-name' })
      end

      it 'configures using custom name' do
        is_expected.to contain_package('designate-worker').with(
          :name      => 'designate-worker-custom-name',
          :ensure    => 'present',
          :tag       => ['openstack', 'designate-package'],
        )
      end
    end

    context 'with all params' do
      before do
        params.merge!( params_all )
      end

      it 'configures designate-worker with all parameters' do
        is_expected.to contain_designate_config('service:worker/workers').with_value( params[:workers] )
        is_expected.to contain_designate_config('service:worker/threads').with_value( params[:threads] )
        is_expected.to contain_designate_config('service:worker/threshold_percentage').with_value( params[:threshold_percentage] )
        is_expected.to contain_designate_config('service:worker/poll_timeout').with_value( params[:poll_timeout] )
        is_expected.to contain_designate_config('service:worker/poll_retry_interval').with_value( params[:poll_retry_interval] )
        is_expected.to contain_designate_config('service:worker/poll_max_retries').with_value( params[:poll_max_retries] )
        is_expected.to contain_designate_config('service:worker/poll_delay').with_value( params[:poll_delay] )
        is_expected.to contain_designate_config('service:worker/notify').with_value( params[:worker_notify] )
        is_expected.to contain_designate_config('service:worker/export_synchronous').with_value( params[:export_synchronous] )
        is_expected.to contain_designate_config('service:worker/topic').with_value( params[:topic] )
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
        case facts[:osfamily]
        when 'Debian'
          {
            :worker_package_name => 'designate-worker',
            :worker_service_name => 'designate-worker'
          }
        when 'RedHat'
          {
            :worker_package_name => 'openstack-designate-worker',
            :worker_service_name => 'designate-worker'
          }
        end
      end
      it_behaves_like 'designate-worker'
    end
  end
end
