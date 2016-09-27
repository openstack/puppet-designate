require 'spec_helper'

describe 'designate::pool_nameserver' do
  shared_examples_for 'designate::pool_nameserver' do
    let :params do
      {
      }
    end

    let :pre_condition do
      'include designate'
    end

    let :title do
      '0f66b842-96c2-4189-93fc-1dc95a08b012'
    end

    context 'without parameters' do
      it { is_expected.to contain_designate__pool_nameserver('0f66b842-96c2-4189-93fc-1dc95a08b012') }

      it 'configures designate pool-nameserver with default parameters' do
        is_expected.to contain_designate_config("pool_nameserver:0f66b842-96c2-4189-93fc-1dc95a08b012/host").with_value('127.0.0.1')
        is_expected.to contain_designate_config("pool_nameserver:0f66b842-96c2-4189-93fc-1dc95a08b012/port").with_value(53)
      end
    end

    context 'with all parameters' do
      before { params.merge!( { :host => '192.168.0.1', :port => 5353 } ) }

      it { is_expected.to contain_designate__pool_nameserver('0f66b842-96c2-4189-93fc-1dc95a08b012') }

      it 'configures designate pool-nameserver with default parameters' do
        is_expected.to contain_designate_config("pool_nameserver:0f66b842-96c2-4189-93fc-1dc95a08b012/host").with_value('192.168.0.1')
        is_expected.to contain_designate_config("pool_nameserver:0f66b842-96c2-4189-93fc-1dc95a08b012/port").with_value(5353)
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

      it_behaves_like 'designate::pool_nameserver'
    end
  end
end
