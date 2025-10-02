require 'spec_helper'

describe 'designate::coordination' do
  shared_examples 'designate::coordination' do
    context 'with default parameters' do
      it {
        is_expected.to contain_oslo__coordination('designate_config').with(
          :backend_url            => '<SERVICE DEFAULT>',
          :manage_backend_package => true,
          :package_ensure         => 'present',
        )
        is_expected.to contain_designate_config('coordination/heartbeat_interval').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_designate_config('coordination/run_watchers_interval').with_value('<SERVICE DEFAULT>')
      }
    end

    context 'with specified parameters' do
      let :params do
        {
          :backend_url            => 'etcd3+http://127.0.0.1:2379',
          :heartbeat_interval     => 5.0,
          :run_watchers_interval  => 10.0,
          :manage_backend_package => false,
          :package_ensure         => 'latest',
        }
      end

      it {
        is_expected.to contain_oslo__coordination('designate_config').with(
          :backend_url            => 'etcd3+http://127.0.0.1:2379',
          :manage_backend_package => false,
          :package_ensure         => 'latest',
        )
        is_expected.to contain_designate_config('coordination/heartbeat_interval').with_value(5.0)
        is_expected.to contain_designate_config('coordination/run_watchers_interval').with_value(10.0)
      }
    end
  end

  on_supported_os({
    :supported_os => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge(OSDefaults.get_facts())
      end

      it_behaves_like 'designate::coordination'
    end
  end
end
