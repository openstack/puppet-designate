#
# Unit tests for designate::client
#
require 'spec_helper'

describe 'designate::client' do

  shared_examples 'designate-client' do

    context 'with default parameters' do
      it { is_expected.to contain_class('designate::deps') }
      it { is_expected.to contain_class('designate::params') }

      it 'installs designate client package' do
        is_expected.to contain_package('python-designateclient').with(
          :ensure => 'present',
          :name   => platform_params[:client_package_name],
          :tag    => ['openstack', 'openstackclient']
        )
      end

      it { is_expected.to contain_class('openstacklib::openstackclient') }
    end

    context 'with custom package name' do
      let :params do
        { :client_package_name => 'designate-client-custom-name' }
      end

      it 'configures using custom name' do
        is_expected.to contain_package('python-designateclient').with(
          :ensure    => 'present',
          :name      => 'designate-client-custom-name',
          :tag       => ['openstack', 'openstackclient'],
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
        case facts[:os]['family']
        when 'Debian'
          { :client_package_name => 'python3-designateclient' }
        when 'RedHat'
          { :client_package_name => 'python3-designateclient' }
        end
      end
      it_behaves_like 'designate-client'
    end
  end
end
