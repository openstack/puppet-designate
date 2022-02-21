#
# Unit tests for designate::agent::bind9
#
require 'spec_helper'

describe 'designate::agent::bind9' do

  shared_examples 'designate::agent::bind9' do
    context 'with default params' do
      let :params do
        {}
      end

      it 'configures the default parameters' do
        is_expected.to contain_designate_config('backend:agent:bind9/rndc_host').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_designate_config('backend:agent:bind9/rndc_port').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_designate_config('backend:agent:bind9/rndc_config_file').with_value('/etc/rndc.conf')
        is_expected.to contain_designate_config('backend:agent:bind9/rndc_key_file').with_value('/etc/rndc.key')
        is_expected.to contain_designate_config('backend:agent:bind9/rndc_timeout').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_designate_config('backend:agent:bind9/zone_file_path').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_designate_config('backend:agent:bind9/query_destination').with_value('<SERVICE DEFAULT>')
      end
    end

    context 'with parameters' do
      let :params do
        {
          :rndc_host         => '10.0.0.42',
          :rndc_port         => '1337',
          :rndc_timeout      => 10,
          :zone_file_path    => '/var/lib/designate/zones',
          :query_destination => '10.0.0.43',
        }
      end

      it 'configures the parameters accordingly' do
        is_expected.to contain_designate_config('backend:agent:bind9/rndc_host').with_value('10.0.0.42')
        is_expected.to contain_designate_config('backend:agent:bind9/rndc_port').with_value('1337')
        is_expected.to contain_designate_config('backend:agent:bind9/rndc_timeout').with_value(10)
        is_expected.to contain_designate_config('backend:agent:bind9/zone_file_path').with_value('/var/lib/designate/zones')
        is_expected.to contain_designate_config('backend:agent:bind9/query_destination').with_value('10.0.0.43')
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
      it_behaves_like 'designate::agent::bind9'
    end
  end

end
