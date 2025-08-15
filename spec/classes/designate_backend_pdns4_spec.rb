#
# Unit tests for designate::backend::pdns4
#
require 'spec_helper'

describe 'designate::backend::pdns4' do

  shared_examples 'designate-backend-pdns4' do

    let :params do
      { :api_token => 'mytoken' }
    end

    context 'with default params' do
      it 'configures named and pool' do
        is_expected.to contain_file('/etc/designate/pools.yaml').with(
          :ensure => 'file',
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

      it_behaves_like 'designate-backend-pdns4'
    end
  end

end
