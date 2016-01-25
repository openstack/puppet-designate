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

    context 'with specific parameters' do
      let :params do
        { :database_connection     => 'mysql+pymysql://designate:designate@localhost/designate',
        }
      end

      it { is_expected.to contain_designate_config('storage:sqlalchemy/connection').with_value('mysql+pymysql://designate:designate@localhost/designate').with_secret(true) }
    end

    context 'with MySQL-python library as backend package' do
      let :params do
        { :database_connection     => 'mysql://designate:designate@localhost/designate', }
      end

      it { is_expected.to contain_package('python-mysqldb').with(:ensure => 'present') }
    end
  end

  shared_examples_for 'designate::db on Debian' do
    context 'using pymysql driver' do
      let :params do
        { :database_connection => 'mysql+pymysql://designate:designate@localhost/designate', }
      end

      it 'install the proper backend package' do
        is_expected.to contain_package('designate-backend-package').with(
          :ensure => 'present',
          :name   => 'python-pymysql',
          :tag    => 'openstack'
        )
      end
    end
  end


  shared_examples_for 'designate::db on RedHat' do
    context 'using pymysql driver' do
      let :params do
        { :database_connection  => 'mysql+pymysql://designate:designate@localhost/designate', }
      end

      it { is_expected.not_to contain_package('designate-backend-package') }
    end
  end

  on_supported_os({
    :supported_os   => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts())
      end

      case facts[:osfamily]
      when 'Debian'
        it_configures 'designate::db on Debian'
      when 'RedHat'
        it_configures 'designate::db on RedHat'
      end
      it_configures 'designate::db'
    end
  end
end
