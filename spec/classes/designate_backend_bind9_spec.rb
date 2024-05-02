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
      it 'configures the bind9 pool' do
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
  end

  on_supported_os({
    :supported_os => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts())
      end

      it_behaves_like 'designate-backend-bind9'
    end
  end

end
