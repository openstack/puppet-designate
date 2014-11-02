#
# Unit tests for designate::backend::bind9
#
require 'spec_helper'

describe 'designate::backend::bind9' do

  let :facts do
    { :osfamily => 'Debian' }
  end

  context 'with default params' do
    it 'configures designate backend bind9 with default parameters' do
      should contain_designate_config('backend:bind9/rndc_host').with_value('127.0.0.1')
      should contain_designate_config('backend:bind9/rndc_port').with_value('953')
      should contain_designate_config('backend:bind9/rndc_config_file').with_value('/etc/rndc.conf')
      should contain_designate_config('backend:bind9/rndc_key_file').with_value('/etc/rndc.key')
      should contain_file_line('dns allow-new-zones')
    end
  end

  context 'when overriding rndc_config_file' do
    let :params do
      { :rndc_config_file => '/srv/designate/rndc.conf' }
    end

    it 'configures designate bind9 backend with custom rndc_config_file' do
      should contain_designate_config('backend:bind9/rndc_config_file').with_value(params[:rndc_config_file])
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
      should contain_designate_config('backend:bind9/rndc_port').with_value(params[:rndc_port])
      should contain_designate_config('backend:bind9/rndc_host').with_value(params[:rndc_host])
    end
  end

end
