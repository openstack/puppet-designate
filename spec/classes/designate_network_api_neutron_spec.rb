require 'spec_helper'

describe 'designate::network_api::neutron' do
  shared_examples 'designate::network_api::neutron' do

    context 'with defaults' do
      let :params do
        {}
      end

      it 'configures defaults' do
        is_expected.to contain_designate_config('network_api:neutron/endpoints').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_designate_config('network_api:neutron/endpoint_type').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_designate_config('network_api:neutron/timeout').with_value('<SERVICE DEFAULT>')
      end
    end

    context 'with parameters set' do
      let :params do
        {
          :endpoints     => 'regionOne|http://192.168.1.10:9696,regionTwo|http://192.168.2.10:9696',
          :endpoint_type => 'internalURL',
          :timeout       => 30,
        }
      end

      it 'configures the defined values' do
        is_expected.to contain_designate_config('network_api:neutron/endpoints').with_value(params[:endpoints])
        is_expected.to contain_designate_config('network_api:neutron/endpoint_type').with_value(params[:endpoint_type])
        is_expected.to contain_designate_config('network_api:neutron/timeout').with_value(params[:timeout])
      end
    end

    context 'with endpoints in array' do
      let :params do
        {
          :endpoints     => ['regionOne|http://192.168.1.10:9696', 'regionTwo|http://192.168.2.10:9696']
        }
      end

      it 'configures the endpoints in string' do
        is_expected.to contain_designate_config('network_api:neutron/endpoints').with_value(
          'regionOne|http://192.168.1.10:9696,regionTwo|http://192.168.2.10:9696'
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

      it_behaves_like 'designate::network_api::neutron'
    end
  end
end
