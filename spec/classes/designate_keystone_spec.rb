require 'spec_helper'

describe 'designate::keystone' do
  shared_examples 'designate::keystone' do

    let :params do
      {}
    end

    context 'with required parameters' do
      it 'configures keystone in designate.conf' do
        should contain_designate_config('keystone/timeout').with_value('<SERVICE DEFAULT>')
        should contain_designate_config('keystone/service_type').with_value('<SERVICE DEFAULT>')
        should contain_designate_config('keystone/valid_interfaces').with_value('<SERVICE DEFAULT>')
        should contain_designate_config('keystone/endpoint_override').with_value('<SERVICE DEFAULT>')
        should contain_designate_config('keystone/region_name').with_value('<SERVICE DEFAULT>')
        should contain_designate_config('keystone/connect_retries').with_value('<SERVICE DEFAULT>')
        should contain_designate_config('keystone/connect_retry_delay').with_value('<SERVICE DEFAULT>')
        should contain_designate_config('keystone/status_code_retries').with_value('<SERVICE DEFAULT>')
        should contain_designate_config('keystone/status_code_retry_delay').with_value('<SERVICE DEFAULT>')
      end
    end

    context 'with parameters' do
      before do
        params.merge!({
          :timeout           => 60,
          :service_type      => 'identity',
          :valid_interfaces  => ['internal', 'public'],
          :endpoint_override => 'http://10.0.0.11:5000/',
          :region_name       => 'RegionOne',
        })
      end

      it 'configures keystone in designate.conf' do
        should contain_designate_config('keystone/timeout').with_value(60)
        should contain_designate_config('keystone/service_type').with_value('identity')
        should contain_designate_config('keystone/valid_interfaces').with_value('internal,public')
        should contain_designate_config('keystone/endpoint_override').with_value('http://10.0.0.11:5000/')
        should contain_designate_config('keystone/region_name').with_value('RegionOne')
        should contain_designate_config('keystone/connect_retries').with_value('<SERVICE DEFAULT>')
        should contain_designate_config('keystone/connect_retry_delay').with_value('<SERVICE DEFAULT>')
        should contain_designate_config('keystone/status_code_retries').with_value('<SERVICE DEFAULT>')
        should contain_designate_config('keystone/status_code_retry_delay').with_value('<SERVICE DEFAULT>')
      end
    end
  end

  on_supported_os({
    :supported_os => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge(OSDefaults.get_facts())
      end

      it_behaves_like 'designate::keystone'
    end
  end
end
