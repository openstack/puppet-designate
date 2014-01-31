require 'spec_helper'

describe 'designate::db::mysql' do

  let :pre_condition do
    'include mysql::server'
  end

  let :params do
    { :password  => 's3cr3t',
      :dbname    => 'designate',
      :user      => 'designate',
      :host      => 'localhost',
      :charset   => 'latin1'
    }
  end

  shared_examples_for 'designate mysql database' do

    context 'when omiting the required parameter password' do
      before { params.delete(:password) }
      it { expect { should raise_error(Puppet::Error) } }
    end

    it 'creates a mysql database' do
      should contain_mysql__db( params[:dbname] ).with(
        :user     => params[:user],
        :password => params[:password],
        :host     => params[:host],
        :charset  => params[:charset],
        :require  => 'Class[Mysql::Config]'
      )
    end
  end

  context 'on Debian platforms' do
    let :facts do
      { :osfamily => 'Debian' }
    end

    it_configures 'designate mysql database'
  end

  context 'on RedHat platforms' do
    let :facts do
      { :osfamily => 'RedHat' }
    end

    it_configures 'designate mysql database'
  end

  describe "overriding allowed_hosts param to array" do
    let :facts do
      { :osfamily => "Debian" }
    end
    let :params do
      {
        :password       => 'designatepass',
        :allowed_hosts  => ['localhost','%']
      }
    end

    it {should_not contain_designate__db__mysql__host_access("localhost").with(
      :user     => 'designate',
      :password => 'designatepass',
      :database => 'designate'
    )}
    it {should contain_designate__db__mysql__host_access("%").with(
      :user     => 'designate',
      :password => 'designatepass',
      :database => 'designate'
    )}
  end

  describe "overriding allowed_hosts param to string" do
    let :facts do
      { :osfamily => 'RedHat' }
    end
    let :params do
      {
        :password       => 'designatepass2',
        :allowed_hosts  => '192.168.1.1'
      }
    end

    it {should contain_designate__db__mysql__host_access("192.168.1.1").with(
      :user     => 'designate',
      :password => 'designatepass2',
      :database => 'designate'
    )}
  end

  describe "overriding allowed_hosts param equals to host param " do
    let :facts do
      { :osfamily => 'RedHat' }
    end
    let :params do
      {
        :password       => 'designatepass2',
        :allowed_hosts  => 'localhost'
      }
    end

    it {should_not contain_designate__db__mysql__host_access("localhost").with(
      :user     => 'designate',
      :password => 'designatepass2',
      :database => 'designate'
    )}
  end
end
