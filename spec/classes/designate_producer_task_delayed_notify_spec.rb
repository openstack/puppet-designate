#
# Unit tests for designate::producer_task::delayed_notify
#
require 'spec_helper'


describe 'designate::producer_task::delayed_notify' do

  shared_examples 'designate::producer_task::delayed_notify' do
    context 'with default parameters' do
      it 'configures the default values' do
        is_expected.to contain_designate_config('producer_task:delayed_notify/interval').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_designate_config('producer_task:delayed_notify/per_page').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_designate_config('producer_task:delayed_notify/batch_size').with_value('<SERVICE DEFAULT>')
      end
    end

    context 'with parameters set' do
      let :params do
        {
          :interval   => 5,
          :per_page   => 100,
          :batch_size => 101,
        }
      end
      it 'configures the overridden values' do
        is_expected.to contain_designate_config('producer_task:delayed_notify/interval').with_value(5)
        is_expected.to contain_designate_config('producer_task:delayed_notify/per_page').with_value(100)
        is_expected.to contain_designate_config('producer_task:delayed_notify/batch_size').with_value(101)
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

      it_configures 'designate::producer_task::delayed_notify'
    end
  end
end
