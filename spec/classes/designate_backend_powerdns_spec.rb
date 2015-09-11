#
# Unit tests for designate::backend::powerdns
#
require 'spec_helper'

describe 'designate::backend::powerdns' do

  let :facts do
    { :osfamily => 'Debian' }
  end

  let :params do
    { :database_connection => 'mysql://dbserver' }
  end

  context 'with default params' do
    it 'configures designate backend powerdns with default parameters' do
      is_expected.to contain_designate_config('backend:powerdns/connection').with_value('mysql://dbserver')
      is_expected.to contain_designate_config('backend:powerdns/use_db_reconnect').with_value(true)
      is_expected.to contain_file('/var/lib/designate').with(
        'ensure' => 'directory',
        'owner'  => 'designate',
        'group'  => 'designate',
        'mode'   => '0750',
      )
    end

    it 'includes designate::db::powerdns::sync' do
      is_expected.to contain_class('designate::db::powerdns::sync')
    end
  end

end
