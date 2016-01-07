#
# Unit tests for designate::db
#
require 'spec_helper'

describe 'designate::db' do

  shared_examples 'designate::db' do

    context 'with default parameters' do

      it { is_expected.to contain_designate_config('storage:sqlalchemy/connection').with_value('mysql://designate:designate@localhost/designate').with_secret(true) }
      it { is_expected.to contain_designate_config('storage:sqlalchemy/idle_timeout').with_value('3600') }
      it { is_expected.to contain_designate_config('storage:sqlalchemy/min_pool_size').with_value('1') }
      it { is_expected.to contain_designate_config('storage:sqlalchemy/max_retries').with_value('10') }
      it { is_expected.to contain_designate_config('storage:sqlalchemy/retry_interval').with_value('10') }

    end

    context 'with specific parameters' do
      let :params do
        { :database_connection     => 'mysql://designate:designate@localhost/designate',
          :database_idle_timeout   => '3601',
          :database_min_pool_size  => '2',
          :database_max_retries    => '11',
          :database_retry_interval => '11', }
      end

      it { is_expected.to contain_designate_config('storage:sqlalchemy/connection').with_value('mysql://designate:designate@localhost/designate').with_secret(true) }
      it { is_expected.to contain_designate_config('storage:sqlalchemy/idle_timeout').with_value('3601') }
      it { is_expected.to contain_designate_config('storage:sqlalchemy/min_pool_size').with_value('2') }
      it { is_expected.to contain_designate_config('storage:sqlalchemy/max_retries').with_value('11') }
      it { is_expected.to contain_designate_config('storage:sqlalchemy/retry_interval').with_value('11') }

    end

    context 'with incorrect database_connection string' do
      let :params do
        { :database_connection     => 'redis://designate:designate@localhost/designate', }
      end

      it_raises 'a Puppet::Error', /validate_re/
    end

  end

  context 'on Debian platforms' do
    let :facts do
      { :osfamily => 'Debian' }
    end

    it_configures 'designate::db'
  end

  context 'on RedHat platforms' do
    let :facts do
      { :osfamily => 'RedHat' }
    end

    it_configures 'designate::db'
  end

end
