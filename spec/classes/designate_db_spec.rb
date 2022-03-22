require 'spec_helper'

describe 'designate::db' do
  shared_examples 'designate::db' do
    context 'with default parameters' do
      it { is_expected.to contain_class('designate::deps') }

      it { is_expected.to contain_oslo__db('designate_config').with(
        :config_group            => 'storage:sqlalchemy',
        :db_max_retries          => '<SERVICE DEFAULT>',
        :connection              => 'mysql://designate:designate@localhost/designate',
        :connection_recycle_time => '<SERVICE DEFAULT>',
        :max_pool_size           => '<SERVICE DEFAULT>',
        :max_retries             => '<SERVICE DEFAULT>',
        :retry_interval          => '<SERVICE DEFAULT>',
        :max_overflow            => '<SERVICE DEFAULT>',
        :pool_timeout            => '<SERVICE DEFAULT>',
        :mysql_enable_ndb        => '<SERVICE DEFAULT>',
      )}
    end

    context 'with specific parameters' do
      let :params do
        {
          :database_db_max_retries          => '-1',
          :database_connection              => 'mysql+pymysql://designate:designate@localhost/designate',
          :database_connection_recycle_time => '3601',
          :database_max_pool_size           => '11',
          :database_max_retries             => '11',
          :database_retry_interval          => '11',
          :database_max_overflow            => '21',
          :database_pool_timeout            => '21',
          :mysql_enable_ndb                 => true,
        }
      end

      it { is_expected.to contain_class('designate::deps') }

      it { is_expected.to contain_oslo__db('designate_config').with(
        :config_group            => 'storage:sqlalchemy',
        :db_max_retries          => '-1',
        :connection              => 'mysql+pymysql://designate:designate@localhost/designate',
        :connection_recycle_time => '3601',
        :max_pool_size           => '11',
        :max_retries             => '11',
        :retry_interval          => '11',
        :max_overflow            => '21',
        :pool_timeout            => '21',
        :mysql_enable_ndb        => true,
      )}
    end
  end

  on_supported_os({
    :supported_os => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts())
      end

      it_behaves_like 'designate::db'
    end
  end
end
