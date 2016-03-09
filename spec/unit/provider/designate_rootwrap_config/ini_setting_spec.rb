$LOAD_PATH.push(
  File.join(
    File.dirname(__FILE__),
    '..',
    '..',
    '..',
    'fixtures',
    'modules',
    'inifile',
    'lib')
)
$LOAD_PATH.push(
  File.join(
    File.dirname(__FILE__),
    '..',
    '..',
    '..',
    'fixtures',
    'modules',
    'openstacklib',
    'lib')
)

require 'spec_helper'
provider_class = Puppet::Type.type(:designate_rootwrap_config).provider(:ini_setting)
describe provider_class do
  it 'should allow setting to be set explicitly' do
    resource = Puppet::Type::Designate_rootwrap_config.new(
      {:name => 'boo/zoo', :value => 'plop'}
    )
    provider = provider_class.new(resource)
    expect(provider.section).to eq('boo')
    expect(provider.setting).to eq('zoo')
  end
end
