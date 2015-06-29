#
# Unit tests for designate::db::powerdns::sync
#
require 'spec_helper'

describe 'designate::db::powerdns::sync' do

  let :facts do
    { :osfamily => 'Debian' }
  end

  it 'runs designate-powerdns-dbsync' do
    is_expected.to contain_exec('designate-powerdns-dbsync').with(
      :command     => 'designate-manage powerdns sync',
      :path        => '/usr/bin',
      :user        => 'root',
      :refreshonly => 'true',
      :logoutput   => 'on_failure',
      :subscribe   => 'Anchor[designate::config::end]',
      :notify      => 'Anchor[designate::service::begin]',
    )
  end

end
