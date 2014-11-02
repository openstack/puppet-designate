#
# Unit tests for designate::db
#
require 'spec_helper'

describe 'designate::db' do

  shared_examples 'designate-db' do

    context 'with default params' do
      it 'configures designate db with default parameters' do
        should contain_designate_config('storage:sqlalchemy/database_connection').with_value('mysql://designate:designate@localhost/designate')
        should contain_class('mysql::bindings')
        should contain_class('mysql::bindings::python')
        should contain_exec('designate-dbinit').with(:notify => 'Exec[designate-dbsync]')
        should contain_exec('designate-dbsync')
      end
    end

  end

  context 'on Debian platforms' do
    let :facts do
      { :osfamily => 'Debian' }
    end

    it_configures 'designate-db'
  end

  context 'on RedHat platforms' do
    let :facts do
      { :osfamily => 'RedHat' }
    end

    it_configures 'designate-db'
  end

end
