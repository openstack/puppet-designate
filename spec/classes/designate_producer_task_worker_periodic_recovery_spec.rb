#
# Unit tests for designate::producer_task::worker_periodic_recovery
#
require 'spec_helper'


describe 'designate::producer_task::worker_periodic_recovery' do

  shared_examples 'designate::producer_task::worker_periodic_recovery' do
    context 'with default parameters' do
      it 'configures the default values' do
        is_expected.to contain_designate_config('producer_task:worker_periodic_recovery/interval').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_designate_config('producer_task:worker_periodic_recovery/per_page').with_value('<SERVICE DEFAULT>')
      end
    end

    context 'with parameters set' do
      let :params do
        {
          :interval => 100,
          :per_page => 120,
        }
      end
      it 'configures the overridden values' do
        is_expected.to contain_designate_config('producer_task:worker_periodic_recovery/interval').with_value(100)
        is_expected.to contain_designate_config('producer_task:worker_periodic_recovery/per_page').with_value(120)
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

      it_configures 'designate::producer_task::worker_periodic_recovery'
    end
  end
end
