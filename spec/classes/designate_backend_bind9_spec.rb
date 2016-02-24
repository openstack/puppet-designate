#
# Unit tests for designate::backend::bind9
#
require 'spec_helper'

describe 'designate::backend::bind9' do

  shared_examples 'designate-backend-bind9' do
    context 'with default params' do
      it 'configures designate backend bind9 with default parameters' do
        is_expected.to contain_designate_config('backend:bind9/rndc_host').with_value('127.0.0.1')
        is_expected.to contain_designate_config('backend:bind9/rndc_port').with_value('953')
        is_expected.to contain_designate_config('backend:bind9/rndc_config_file').with_value('/etc/rndc.conf')
        is_expected.to contain_designate_config('backend:bind9/rndc_key_file').with_value('/etc/rndc.key')
        is_expected.to contain_file_line('dns allow-new-zones').with( :path => platform_params[:dns_optionspath], :line => 'allow-new-zones yes;')
      end
    end

    context 'when overriding rndc_config_file' do
      let :params do
        { :rndc_config_file => '/srv/designate/rndc.conf' }
      end

      it 'configures designate bind9 backend with custom rndc_config_file' do
        is_expected.to contain_designate_config('backend:bind9/rndc_config_file').with_value(params[:rndc_config_file])
      end
    end

    context 'when overriding rndc_host and rndc_port' do
      let :params do
        {
          :rndc_host => '10.0.0.42',
          :rndc_port => '1337'
        }
      end

      it 'configures designate bind9 backend with custom rndc_port and rndc_host' do
        is_expected.to contain_designate_config('backend:bind9/rndc_port').with_value(params[:rndc_port])
        is_expected.to contain_designate_config('backend:bind9/rndc_host').with_value(params[:rndc_host])
      end
    end
  end

  on_supported_os({
    :supported_os => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts({
          :concat_basedir => '/var/lib/puppet/concat',
        }))
      end

      let(:platform_params) do
        case facts[:osfamily]
        when 'Debian'
          {
          :dns_optionspath => '/etc/bind/named.conf.options'
          }
        when 'RedHat'
          {
          :dns_optionspath => '/etc/named/options.conf'
          }
        end
      end
      it_behaves_like 'designate-backend-bind9'
    end
  end

end
