#
# Unit tests for designate::client
#
require 'spec_helper'

describe 'designate::client' do
  let :params do
    { }
  end

  shared_examples 'designate-client' do

    context 'with default parameters' do
      it { is_expected.to contain_class('designate::deps') }
      it { is_expected.to contain_class('designate::params') }

      it 'installs designate client package' do
        is_expected.to contain_package('python-designateclient').with(
          :ensure => 'present',
          :name   => platform_params[:client_package_name],
          :tag    => 'openstack'
        )
      end
    end

    context 'with custom package name' do
      before do
        params.merge!({ :client_package_name => 'designate-client-custom-name' })
      end

      it 'configures using custom name' do
        is_expected.to contain_package('python-designateclient').with(
          :ensure    => 'present',
          :name      => 'designate-client-custom-name',
          :tag       => 'openstack',
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

      let(:platform_params) do
        case facts[:osfamily]
        when 'Debian'
          { :client_package_name => 'python-designateclient' }
        when 'RedHat'
          { :client_package_name => 'python-designateclient' }
        end
      end
      it_behaves_like 'designate-client'
    end
  end
end
