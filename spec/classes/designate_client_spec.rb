#
# Unit tests for designate::client
#
require 'spec_helper'

describe 'designate::client' do

  shared_examples 'designate-client' do

    it { is_expected.to contain_class('designate::params') }

    it 'installs designate client package' do
      is_expected.to contain_package('python-designateclient').with(
        :ensure => 'present',
        :name   => platform_params[:client_package_name],
        :tag    => 'openstack'
      )
    end
  end

  context 'on Debian platforms' do
    let :facts do
      { :osfamily => 'Debian' }
    end

    let :platform_params do
      { :client_package_name => 'python-designateclient' }
    end

    it_configures 'designate-client'
  end

  context 'on RedHat platforms' do
    let :facts do
      { :osfamily => 'RedHat' }
    end

    let :platform_params do
      { :client_package_name => 'python-designateclient' }
    end

    it_configures 'designate-client'
  end

  context 'with custom package name' do
    let :facts do
      { :osfamily => 'RedHat' }
    end

    let :platform_params do
      { :client_package_name => 'designate-client-custom-name' }
    end

    let :params do
      { :client_package_name => 'designate-client-custom-name' }
    end

    it_configures 'designate-client'
  end
end
