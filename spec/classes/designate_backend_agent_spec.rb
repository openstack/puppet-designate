#
# Unit tests for designate::backend::agent
#
require 'spec_helper'

describe 'designate::backend::agent' do

  shared_examples 'designate-backend-agent' do
    context 'with default params' do
      it 'configures named and pool' do
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

      it_behaves_like 'designate-backend-agent'
    end
  end

end
