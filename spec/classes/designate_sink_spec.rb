#
# Unit tests for designate::sink
#
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
        is_expected.to contain_designate_config('service:sink/enabled_notification_handlers').with_ensure('absent')
      end

      context 'when using enabled_notification_handlers' do
        before { params.merge!(:enabled_notification_handlers => ['nova_fixed','neutron_floatingip']) }
        it 'configures designate-sink with enabled_notification_handlers' do
          is_expected.to contain_designate_config('service:sink/enabled_notification_handlers').with_value(['nova_fixed,neutron_floatingip'])
        end
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
        case facts[:osfamily]
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
