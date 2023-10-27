#
# Unit tests for designate::backend::bind9
#
require 'spec_helper'

describe 'designate::backend::bind9' do

  shared_examples 'designate-backend-bind9' do
    context 'with default params' do
      let :params do
        {}
      end
      it 'configures named and pool' do
        is_expected.to contain_class('dns').with(
          :additional_options => {
            'allow-new-zones'   => 'yes',
            'minimal-responses' => 'yes'
          },
        )
        is_expected.to contain_file('/etc/designate/pools.yaml').with(
          :ensure => 'present',
          :path   => '/etc/designate/pools.yaml',
          :owner  => 'designate',
          :group  => 'designate',
          :mode   => '0640',
        )
        is_expected.to contain_exec('designate-manage pool update').with(
          :command     => 'designate-manage pool update',
          :path        => '/usr/bin',
          :user        => 'designate',
          :refreshonly => true,
        )
      end
    end

    context 'with named configuration disabled' do
      let :params do
        { :configure_bind => false }
      end
      it 'does not configure named' do
        is_expected.to_not contain_class('dns')
      end
    end

    context 'with pool management disabled' do
      let :params do
        { :manage_pool => false }
      end
      it 'does not configure pool' do
        is_expected.to_not contain_file('/etc/designate/pools.yaml')
        is_expected.to_not contain_exec('designate-manage pool update')
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
