require 'puppet'
require 'puppet/type/designate_rootwrap_config'
describe 'Puppet::Type.type(:designate_rootwrap_config)' do
  before :each do
    @designate_rootwrap_config = Puppet::Type.type(:designate_rootwrap_config).new(:name => 'DEFAULT/foo', :value => 'bar')
  end

  it 'should require a name' do
    expect {
      Puppet::Type.type(:designate_rootwrap_config).new({})
    }.to raise_error(Puppet::Error, 'Title or name must be provided')
  end

  it 'should not expect a name with whitespace' do
    expect {
      Puppet::Type.type(:designate_rootwrap_config).new(:name => 'f oo')
    }.to raise_error(Puppet::Error, /Parameter name failed/)
  end

  it 'should fail when there is no section' do
    expect {
      Puppet::Type.type(:designate_rootwrap_config).new(:name => 'foo')
    }.to raise_error(Puppet::Error, /Parameter name failed/)
  end

  it 'should not require a value when ensure is absent' do
    expect {
      Puppet::Type.type(:designate_rootwrap_config).new(:name => 'DEFAULT/foo', :ensure => :absent)
    }.not_to raise_error
  end

  it 'should accept a valid value' do
    @designate_rootwrap_config[:value] = 'bar'
    expect(@designate_rootwrap_config[:value]).to eq('bar')
  end

  it 'should accept a value with whitespace' do
    @designate_rootwrap_config[:value] = 'b ar'
    expect(@designate_rootwrap_config[:value]).to eq('b ar')
  end

  it 'should accept valid ensure values' do
    @designate_rootwrap_config[:ensure] = :present
    expect(@designate_rootwrap_config[:ensure]).to eq(:present)
    @designate_rootwrap_config[:ensure] = :absent
    expect(@designate_rootwrap_config[:ensure]).to eq(:absent)
  end

  it 'should not accept invalid ensure values' do
    expect {
      @designate_rootwrap_config[:ensure] = :latest
    }.to raise_error(Puppet::Error, /Invalid value/)
  end

  it 'should autorequire the package that install the file' do
    catalog = Puppet::Resource::Catalog.new
    package = Puppet::Type.type(:package).new(:name => 'designate-common')
    catalog.add_resource package, @designate_rootwrap_config
    dependency = @designate_rootwrap_config.autorequire
    expect(dependency.size).to eq(1)
    expect(dependency[0].target).to eq(@designate_rootwrap_config)
    expect(dependency[0].source).to eq(package)
  end

end
