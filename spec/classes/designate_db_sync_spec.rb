#
# Unit tests for designate::db::sync
#
require 'spec_helper'

describe 'designate::db::sync' do

  shared_examples_for 'designate-db-sync' do
    context 'with default parameters' do

      it { is_expected.to contain_class('designate::deps') }

      it 'runs designate-db-sync' do
        is_expected.to contain_exec('designate-dbsync').with(
          :command     => 'designate-manage  database sync',
          :path        => '/usr/bin',
          :user        => 'designate',
          :refreshonly => 'true',
          :try_sleep   => 5,
          :tries       => 10,
          :timeout     => 300,
          :logoutput   => 'on_failure',
          :subscribe   => ['Anchor[designate::install::end]',
                           'Anchor[designate::config::end]',
                           'Anchor[designate::dbsync::begin]'],
          :notify      => 'Anchor[designate::dbsync::end]',
          :tag         => 'openstack-db',
        )
      end
    end

    context 'with parameter overrides' do
      let :params do
        {
          :extra_params    => '--config-file /etc/designate/designate.conf',
          :db_sync_timeout => 750,
        }
      end
      it 'runs designate manage with diffent config' do
        is_expected.to contain_exec('designate-dbsync').with(
          :command     => 'designate-manage --config-file /etc/designate/designate.conf database sync',
          :path        => '/usr/bin',
          :user        => 'designate',
          :refreshonly => 'true',
          :try_sleep   => 5,
          :tries       => 10,
          :timeout     => 750,
          :logoutput   => 'on_failure',
          :subscribe   => ['Anchor[designate::install::end]',
                           'Anchor[designate::config::end]',
                           'Anchor[designate::dbsync::begin]'],
          :notify      => 'Anchor[designate::dbsync::end]',
          :tag         => 'openstack-db',
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

      it_behaves_like 'designate-db-sync'
    end
  end
end
