require 'spec_helper'
provider_class = Puppet::Type.type(:designate_api_paste_ini).provider(:ini_setting)
describe provider_class do

  it 'should allow setting to be set explicitly' do
    resource = Puppet::Type::Designate_api_paste_ini.new(
      {:name => 'boo/zoo', :value => 'plop'}
    )
    provider = provider_class.new(resource)
    expect(provider.section).to  eq('boo')
    expect(provider.setting).to eq('zoo')
  end

  it 'should ensure absent when <SERVICE DEFAULT> is specified as a value' do
    resource = Puppet::Type::Designate_api_paste_ini.new(
      {:name => 'dude/foo', :value => '<SERVICE DEFAULT>'}
    )
    provider = provider_class.new(resource)
    provider.exists?
    expect(resource[:ensure]).to eq :absent
  end

  it 'should ensure absent when value matches ensure_absent_val' do
    resource = Puppet::Type::Designate_api_paste_ini.new(
      {:name => 'dude/foo', :value => 'foo', :ensure_absent_val => 'foo' }
    )
    provider = provider_class.new(resource)
    provider.exists?
    expect(resource[:ensure]).to eq :absent
  end
end
