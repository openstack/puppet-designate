#
# Unit tests for designate::dns
#
require 'spec_helper'

describe 'designate::dns' do

  shared_examples 'designate-dns' do

    it 'configures designate configuration folder' do
      is_expected.to contain_file(params[:designatepath]).with(:ensure => 'directory')
    end

    it 'configures designate configuration file' do
      is_expected.to contain_file(params[:designatefile])
    end

  end

  context 'on Debian platforms' do
    let :facts do
      { :osfamily => 'Debian' }
    end

    let :params do
      {
        :designatepath => '/var/cache/bind/bind9',
        :designatefile => '/var/cache/bind/bind9/zones.config'
      }
    end

    it_configures 'designate-dns'
  end

  context 'on RedHat platforms' do
    let :facts do
      { :osfamily => 'RedHat' }
    end

    let :params do
      {
        :designatepath => '/var/named/bind9',
        :designatefile => '/var/named/bind9/zones.config'
      }
    end

    it_configures 'designate-dns'
  end
end
