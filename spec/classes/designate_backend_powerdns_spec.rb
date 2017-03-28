#
# Unit tests for designate::backend::powerdns
#
require 'spec_helper'

describe 'designate::backend::powerdns' do

  let :params do
    { :database_connection => 'mysql://dbserver' }
  end

  shared_examples 'designate-backend-powerdns' do
    context 'with default params' do
      it 'configures designate backend powerdns with default parameters' do
        is_expected.to contain_designate_config('backend:powerdns/connection').with_value('mysql://dbserver').with_secret(true)
        is_expected.to contain_designate_config('backend:powerdns/use_db_reconnect').with_value(true)
      end

      it 'includes designate::db::powerdns::sync' do
        is_expected.to contain_class('designate::db::powerdns::sync')
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

      let(:platform_params) do
        case facts[:osfamily]
        when 'Debian'
          { }
        when 'RedHat'
          { }
        end
      end
      it_behaves_like 'designate-backend-powerdns'
    end
  end

end
