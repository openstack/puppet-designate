require 'puppet'
require 'puppet/type/designate_config'
describe 'Puppet::Type.type(:designate_config)' do
  before :each do
    @designate_config = Puppet::Type.type(:designate_config).new(:name => 'DEFAULT/foo', :value => 'bar')
  end

  it 'should require a name' do
    expect {
      Puppet::Type.type(:designate_config).new({})
    }.to raise_error(Puppet::Error, 'Title or name must be provided')
  end

  it 'should not expect a name with whitespace' do
    expect {
      Puppet::Type.type(:designate_config).new(:name => 'f oo')
    }.to raise_error(Puppet::Error, /Parameter name failed/)
  end

  it 'should fail when there is no section' do
    expect {
      Puppet::Type.type(:designate_config).new(:name => 'foo')
    }.to raise_error(Puppet::Error, /Parameter name failed/)
  end

  it 'should not require a value when ensure is absent' do
    Puppet::Type.type(:designate_config).new(:name => 'DEFAULT/foo', :ensure => :absent)
  end

  it 'should accept a valid value' do
    @designate_config[:value] = 'bar'
    @designate_config[:value].should == 'bar'
  end

  it 'should not accept a value with whitespace' do
    @designate_config[:value] = 'b ar'
    @designate_config[:value].should == 'b ar'
  end

  it 'should accept valid ensure values' do
    @designate_config[:ensure] = :present
    @designate_config[:ensure].should == :present
    @designate_config[:ensure] = :absent
    @designate_config[:ensure].should == :absent
  end

  it 'should not accept invalid ensure values' do
    expect {
      @designate_config[:ensure] = :latest
    }.to raise_error(Puppet::Error, /Invalid value/)
  end
end
