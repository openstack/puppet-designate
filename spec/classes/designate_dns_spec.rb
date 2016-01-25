#
# Unit tests for designate::dns
#
require 'spec_helper'

describe 'designate::dns' do

  shared_examples 'designate-dns' do

    it 'configures designate configuration folder' do
      is_expected.to contain_file(params[:designatepath]).with(:ensure => 'directory')
    end

    it 'configures designate configuration file' do
      is_expected.to contain_file(params[:designatefile])
    end

  end

  on_supported_os({
    :supported_os => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts())
      end

      let(:params) do
        case facts[:osfamily]
        when 'Debian'
          {
            :designatepath => '/var/cache/bind/bind9',
            :designatefile => '/var/cache/bind/bind9/zones.config'
          }
        when 'RedHat'
          {
            :designatepath => '/var/named/bind9',
            :designatefile => '/var/named/bind9/zones.config'
          }
        end
      end
      it_behaves_like 'designate-dns'
    end
  end
end
