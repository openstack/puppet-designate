#
# Unit tests for designate::producer_task::periodic_exists
#
require 'spec_helper'


describe 'designate::producer_task::periodic_exists' do

  shared_examples 'designate::producer_task::periodic_exists' do
    context 'with default parameters' do
      it 'configures the default values' do
        is_expected.to contain_designate_config('producer_task:periodic_exists/interval').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_designate_config('producer_task:periodic_exists/per_page').with_value('<SERVICE DEFAULT>')
      end
    end

    context 'with parameters set' do
      let :params do
        {
          :interval => 3600,
          :per_page => 100,
        }
      end
      it 'configures the overridden values' do
        is_expected.to contain_designate_config('producer_task:periodic_exists/interval').with_value(3600)
        is_expected.to contain_designate_config('producer_task:periodic_exists/per_page').with_value(100)
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

      it_configures 'designate::producer_task::periodic_exists'
    end
  end
end
