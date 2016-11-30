#
# Unit tests for designate::db::powerdns::sync
#
require 'spec_helper'

describe 'designate::db::powerdns::sync' do

  shared_examples_for 'designate-db-powerdns-sync' do
    context 'with default parameters' do
      it 'runs designate-powerdns-dbsync' do
        is_expected.to contain_exec('designate-powerdns-dbsync').with(
          :command     => 'designate-manage  powerdns sync',
          :path        => '/usr/bin',
          :user        => 'root',
          :refreshonly => 'true',
          :logoutput   => 'on_failure',
          :subscribe   => ['Anchor[designate::install::end]',
                           'Anchor[designate::config::end]',
                           'Anchor[designate::dbsync::begin]'],
          :notify      => 'Anchor[designate::dbsync::end]',
        )
      end
    end

    context 'with parameter overrides' do
      let :params do
        {
          :extra_params => '--config-file /etc/designate/designate.conf'
        }
      end
      it 'runs designate manage with diffent config' do
        is_expected.to contain_exec('designate-powerdns-dbsync').with(
          :command     => 'designate-manage --config-file /etc/designate/designate.conf powerdns sync',
          :path        => '/usr/bin',
          :user        => 'root',
          :refreshonly => 'true',
          :logoutput   => 'on_failure',
          :subscribe   => ['Anchor[designate::install::end]',
                           'Anchor[designate::config::end]',
                           'Anchor[designate::dbsync::begin]'],
          :notify      => 'Anchor[designate::dbsync::end]',
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

      it_behaves_like 'designate-db-powerdns-sync'
    end
  end
end
