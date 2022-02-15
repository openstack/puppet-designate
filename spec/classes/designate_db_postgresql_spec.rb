require 'spec_helper'

describe 'designate::db::postgresql' do

  shared_examples 'designate::db::postgresql' do
    let :req_params do
      { :password => 'pw' }
    end

    let :pre_condition do
      'include postgresql::server'
    end

    context 'with only required parameters' do
      let :params do
        req_params
      end

      it { is_expected.to contain_class('designate::deps') }

      it { should contain_openstacklib__db__postgresql('designate').with(
        :password   => 'pw',
        :dbname     => 'designate',
        :user       => 'designate',
        :encoding   => nil,
        :privileges => 'ALL',
      )}
    end
  end

  on_supported_os({
    :supported_os   => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge(OSDefaults.get_facts({
          :os_workers     => 8,
          :concat_basedir => '/var/lib/puppet/concat'
        }))
      end

      # TODO(tkajinam): Remove this once puppet-postgresql supports CentOS 9
      unless facts[:osfamily] == 'RedHat' and facts[:operatingsystemmajrelease].to_i >= 9
        it_configures 'designate::db::postgresql'
      end
    end
  end
end
