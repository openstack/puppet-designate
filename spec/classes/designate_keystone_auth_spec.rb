#
# Unit tests for designate::keystone::auth
#
require 'spec_helper'

describe 'designate::keystone::auth' do

  let :facts do
    { :osfamily => 'Debian' }
  end

  describe 'with default class parameters' do
    let :params do
      { :password => 'desigpwd',
        :tenant   => 'fooboozoo' }
    end

    it { should contain_keystone_user('designate').with(
      :ensure   => 'present',
      :password => 'desigpwd',
      :tenant   => 'fooboozoo'
    ) }

    it { should contain_keystone_user_role('designate@fooboozoo').with(
      :ensure  => 'present',
      :roles   => 'admin'
    )}

    it { should contain_keystone_service('designate').with(
      :ensure      => 'present',
      :type        => 'dns',
      :description => 'Openstack DNSaas Service'
    ) }

    it { should contain_keystone_endpoint('RegionOne/designate').with(
      :ensure       => 'present',
      :public_url   => "http://127.0.0.1:9001/v1",
      :admin_url    => "http://127.0.0.1:9001/v1",
      :internal_url => "http://127.0.0.1:9001/v1"
    ) }
  end

  describe 'when configuring designate-server' do
    let :pre_condition do
      "class { 'designate::server': auth_password => 'test' }"
    end

    let :params do
      { :password => 'desigpwd',
        :tenant   => 'fooboozoo' }
    end
  end

  describe 'when overriding public_protocol, public_port and public address' do
    let :params do
      { :password         => 'desigpwd',
        :public_protocol  => 'https',
        :public_address   => '10.10.10.10',
        :port             => '81',
        :internal_address => '10.10.10.11',
        :admin_address    => '10.10.10.12' }
    end

    it { should contain_keystone_endpoint('RegionOne/designate').with(
      :ensure       => 'present',
      :public_url   => "https://10.10.10.10:81/v1",
      :internal_url => "http://10.10.10.11:81/v1",
      :admin_url    => "http://10.10.10.12:81/v1"
    ) }
  end

  describe 'when overriding auth name' do
    let :params do
      { :password => 'foo',
        :auth_name => 'designate1' }
    end

    it { should contain_keystone_user('designate1') }
    it { should contain_keystone_user_role('designate1@services') }
    it { should contain_keystone_service('designate1') }
    it { should contain_keystone_endpoint('RegionOne/designate1') }
  end
end
