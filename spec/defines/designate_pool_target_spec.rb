require 'spec_helper'

describe 'designate::pool_target' do
  let :facts do
    @default_facts.merge({:osfamily => 'Debian'})
  end

  let :params do
    {
      :options => 'rndc_host: 192.168.27.100, rndc_port: 953, rndc_config_file: /etc/bind/rndc.conf, rndc_key_file: /etc/bind/rndc.key, port: 53, host: 192.168.27.100',
      :type    => 'bind9',
      :masters => ['127.0.0.1:5354'],
    }
  end

  let :pre_condition do
    'include designate'
  end

  let :title do
    'f26e0b32-736f-4f0a-831b-039a415c481e'
  end

  shared_examples_for 'with only required parameters' do
    it { is_expected.to contain_designate__pool_target('f26e0b32-736f-4f0a-831b-039a415c481e') }

    it 'configures designate pool-manager pool with default parameters' do
      is_expected.to contain_designate_config('pool_target:f26e0b32-736f-4f0a-831b-039a415c481e/options').with_value(params[:options])
      is_expected.to contain_designate_config('pool_target:f26e0b32-736f-4f0a-831b-039a415c481e/type').with_value(params[:type])
      is_expected.to contain_designate_config('pool_target:f26e0b32-736f-4f0a-831b-039a415c481e/masters').with_value(params[:masters])
    end
  end

  shared_examples_for 'with all parameters' do
    before { params.merge!( { :masters => ['192.168.0.1'] } ) }

    it { is_expected.to contain_designate__pool_target('f26e0b32-736f-4f0a-831b-039a415c481e') }

    it 'configures designate pool-manager pool with default parameters' do
      is_expected.to contain_designate_config('pool_target:f26e0b32-736f-4f0a-831b-039a415c481e/options').with_value(params[:options])
      is_expected.to contain_designate_config('pool_target:f26e0b32-736f-4f0a-831b-039a415c481e/type').with_value(params[:type])
      is_expected.to contain_designate_config('pool_target:f26e0b32-736f-4f0a-831b-039a415c481e/masters').with_value(params[:masters])
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
