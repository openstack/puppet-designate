#
# Unit tests for designate::sink
#
require 'spec_helper'

describe 'designate::sink' do
  let :params do
    {
      :enabled => true
    }
  end

  shared_examples 'designate-sink' do
    context 'with default parameters' do
      it 'installs designate-sink package and service' do
        is_expected.to contain_service('designate-sink').with(
          :name      => platform_params[:sink_service_name],
          :ensure    => 'running',
          :enable    => 'true'
        )
        is_expected.to contain_package('designate-sink').with(
          :name      => platform_params[:sink_package_name],
          :ensure    => 'present',
          :tag       => 'openstack'
        )
      end
    end
  end

  context 'on Debian platforms' do
    let :facts do
      { :osfamily => 'Debian' }
    end

    let :platform_params do
      {
        :sink_package_name => 'designate-sink',
        :sink_service_name => 'designate-sink'
      }
    end

    it_configures 'designate-sink'
  end

  context 'on RedHat platforms' do
    let :facts do
      { :osfamily => 'RedHat' }
    end

    let :platform_params do
      {
        :sink_package_name => 'openstack-designate-sink',
        :sink_service_name => 'openstack-designate-sink'
      }
    end

    it_configures 'designate-sink'
  end

   context 'with custom package name' do
    let :facts do
      { :osfamily => 'RedHat' }
    end

    let :platform_params do
      { :sink_package_name => 'designate-sink-custom-name',
        :sink_service_name => 'openstack-designate-sink'
      }
    end

    before do
      params.merge!({ :sink_package_name => 'designate-sink-custom-name' })
    end

    it_configures 'designate-sink'
  end
end
