require 'spec_helper'

describe 'designate::pool' do
  let :facts do
    @default_facts.merge({:osfamily => 'Debian'})
  end

  let :params do
    {
      :nameservers => ['0f66b842-96c2-4189-93fc-1dc95a08b012'],
      :targets     => ['f26e0b32-736f-4f0a-831b-039a415c481e'],
    }
  end

  let :pre_condition do
    'include designate'
  end

  let :title do
    '794ccc2c-d751-44fe-b57f-8894c9f5c842'
  end

  shared_examples_for 'with only required parameters' do
    it { is_expected.to contain_designate__pool('794ccc2c-d751-44fe-b57f-8894c9f5c842') }

    it 'configures designate pool with default parameters' do
      is_expected.to contain_designate_config("pool:794ccc2c-d751-44fe-b57f-8894c9f5c842/nameservers").with_value( params[:nameservers])
      is_expected.to contain_designate_config("pool:794ccc2c-d751-44fe-b57f-8894c9f5c842/targets").with_value( params[:targets] )
      is_expected.to contain_designate_config("pool:794ccc2c-d751-44fe-b57f-8894c9f5c842/also-notifies").with_value( "" )
    end
  end

  shared_examples_for 'with all parameters' do
    before { params.merge!( { :also_notifies => ["192.168.0.1"] } ) }

    it { is_expected.to contain_designate__pool('794ccc2c-d751-44fe-b57f-8894c9f5c842') }

    it 'configures designate pool with default parameters' do
      is_expected.to contain_designate_config("pool:794ccc2c-d751-44fe-b57f-8894c9f5c842/nameservers").with_value( params[:nameservers])
      is_expected.to contain_designate_config("pool:794ccc2c-d751-44fe-b57f-8894c9f5c842/targets").with_value( params[:targets] )
      is_expected.to contain_designate_config("pool:794ccc2c-d751-44fe-b57f-8894c9f5c842/also-notifies").with_value( ["192.168.0.1"] )
    end
  end

  on_supported_os({
    :supported_os => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts())
      end

      it_behaves_like 'with only required parameters'
      it_behaves_like 'with all parameters'
    end
  end
end
