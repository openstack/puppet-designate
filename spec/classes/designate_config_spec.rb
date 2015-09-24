require 'spec_helper'

describe 'designate::config' do

  let :params do
    { :designate_config => {
        'DEFAULT/foo' => { 'value'  => 'fooValue' },
        'DEFAULT/bar' => { 'value'  => 'barValue' },
        'DEFAULT/baz' => { 'ensure' => 'absent' },
      },
      :api_paste_ini_config => {
        'DEFAULT/foo2' => { 'value'  => 'fooValue' },
        'DEFAULT/bar2' => { 'value'  => 'barValue' },
        'DEFAULT/baz2' => { 'ensure' => 'absent' },
      },
      :rootwrap_config => {
        'DEFAULT/filters_path'        => { 'value' => '/etc/designate/rootwrap.d,/usr/share/designate/rootwrap' },
        'DEFAULT/exec_dirs'           => { 'value' => '/sbin,/usr/sbin,/bin,/usr/bin' },
        'DEFAULT/use_syslog'          => { 'value' => 'False' },
        'DEFAULT/syslog_log_facility' => { 'value' => 'syslog' },
        'DEFAULT/syslog_log_level'    => { 'value' => 'ERROR' },
    },
    }
  end

  it 'configures arbitrary designate configurations' do
    is_expected.to contain_designate_config('DEFAULT/foo').with_value('fooValue')
    is_expected.to contain_designate_config('DEFAULT/bar').with_value('barValue')
    is_expected.to contain_designate_config('DEFAULT/baz').with_ensure('absent')
  end

  it 'configures arbitrary designate api-paste configurations' do
    is_expected.to contain_designate_api_paste_ini('DEFAULT/foo2').with_value('fooValue')
    is_expected.to contain_designate_api_paste_ini('DEFAULT/bar2').with_value('barValue')
    is_expected.to contain_designate_api_paste_ini('DEFAULT/baz2').with_ensure('absent')
  end

  it 'configures arbitrary designate rootwrap configurations' do
    is_expected.to contain_designate_rootwrap_config('DEFAULT/filters_path').with_value('/etc/designate/rootwrap.d,/usr/share/designate/rootwrap')
    is_expected.to contain_designate_rootwrap_config('DEFAULT/exec_dirs').with_value('/sbin,/usr/sbin,/bin,/usr/bin')
    is_expected.to contain_designate_rootwrap_config('DEFAULT/use_syslog').with_value('False')
    is_expected.to contain_designate_rootwrap_config('DEFAULT/syslog_log_facility').with_value('syslog')
    is_expected.to contain_designate_rootwrap_config('DEFAULT/syslog_log_level').with_value('ERROR')
  end
end
