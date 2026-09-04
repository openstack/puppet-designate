#
# Unit tests for designate::producer_task::periodic_check_service_status
#
require 'spec_helper'


describe 'designate::producer_task::periodic_check_service_status' do

  shared_examples 'designate::producer_task::periodic_check_service_status' do
    context 'with default parameters' do
      it 'configures the default values' do
        is_expected.to contain_designate_config('producer_task:periodic_check_service_status/interval').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_designate_config('producer_task:periodic_check_service_status/per_page').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_designate_config('producer_task:periodic_check_service_status/time_threshold').with_value('<SERVICE DEFAULT>')
      end
    end

    context 'with parameters set' do
      let :params do
        {
          :interval       => 3600,
          :per_page       => 100,
          :time_threshold => 1800,
        }
      end
      it 'configures the overridden values' do
        is_expected.to contain_designate_config('producer_task:periodic_check_service_status/interval').with_value(3600)
        is_expected.to contain_designate_config('producer_task:periodic_check_service_status/per_page').with_value(100)
        is_expected.to contain_designate_config('producer_task:periodic_check_service_status/time_threshold').with_value(1800)
      end
    end
  end

  on_supported_os({
    :supported_os   => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts())
      end

      it_configures 'designate::producer_task::periodic_check_service_status'
    end
  end
end
