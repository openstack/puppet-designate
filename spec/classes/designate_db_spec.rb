#
# Unit tests for designate::db
#
require 'spec_helper'

describe 'designate::db' do

  shared_examples 'designate-db' do

    context 'with default params' do
      it 'configures designate db with default parameters' do
        is_expected.to contain_designate_config('storage:sqlalchemy/connection').with_value('mysql://designate:designate@localhost/designate')
        is_expected.to contain_class('mysql::bindings')
        is_expected.to contain_class('mysql::bindings::python')
      end

      it 'includes designate::db::sync' do
        is_expected.to contain_class('designate::db::sync')
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
