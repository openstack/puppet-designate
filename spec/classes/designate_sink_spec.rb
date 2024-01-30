require 'spec_helper'

describe 'designate::sink' do
  let :params do
    {
      :enabled => true
    }
  end

  shared_examples 'designate-sink' do
    context 'with default parameters' do
      it 'installs designate-sink package and service' do
        is_expected.to contain_service('designate-sink').with(
          :name      => platform_params[:sink_service_name],
          :ensure    => 'running',
          :enable    => 'true',
          :tag       => ['openstack', 'designate-service'],
        )
        is_expected.to contain_package('designate-sink').with(
          :name      => platform_params[:sink_package_name],
          :ensure    => 'present',
          :tag       => ['openstack', 'designate-package'],
        )
      end

      it 'configures designate.conf' do
        is_expected.to contain_designate_config('service:sink/workers').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_designate_config('service:sink/threads').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_designate_config('service:sink/enabled_notification_handlers').with_value('<SERVICE DEFAULT>')
      end
    end

    context 'with parameters set' do
      before do
        params.merge!(
          :workers => 4,
          :threads => 1000,
        )
      end

      it 'configures designate.conf' do
        is_expected.to contain_designate_config('service:sink/workers').with_value(4)
        is_expected.to contain_designate_config('service:sink/threads').with_value(1000)
      end
    end

    context 'with enabled_notification_handlers (array)' do
      before do
        params.merge!(
          :enabled_notification_handlers => ['nova_fixed', 'neutron_floatingip']
        )
      end
      it 'configures designate-sink with enabled_notification_handlers' do
        is_expected.to contain_designate_config('service:sink/enabled_notification_handlers').with_value('nova_fixed,neutron_floatingip')
      end
    end

    context 'with enabled_notification_handlers (string)' do
      before do
        params.merge!(
          :enabled_notification_handlers => 'nova_fixed,neutron_floatingip'
        )
      end
      it 'configures designate-sink with enabled_notification_handlers' do
        is_expected.to contain_designate_config('service:sink/enabled_notification_handlers').with_value('nova_fixed,neutron_floatingip')
      end
    end

    context 'with custom package name' do
      before :each do
        params.merge!({ :sink_package_name => 'designate-sink-custom-name' })
      end

      it 'configures using custom name' do
        is_expected.to contain_package('designate-sink').with(
          :name      => 'designate-sink-custom-name',
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
        facts.merge!(OSDefaults.get_facts())
      end

      let(:platform_params) do
        case facts[:os]['family']
        when 'Debian'
          {
            :sink_package_name => 'designate-sink',
            :sink_service_name => 'designate-sink'
          }
        when 'RedHat'
          {
            :sink_package_name => 'openstack-designate-sink',
            :sink_service_name => 'designate-sink'
          }
        end
      end
      it_behaves_like 'designate-sink'
    end
  end

end
