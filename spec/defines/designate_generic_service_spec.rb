require 'spec_helper'

describe 'designate::generic_service' do
  describe 'should configure related package and service' do
    let :pre_condition do
      'include designate'
    end

    let :params do
      {
        :package_name   => 'foo',
        :service_name   => 'food',
        :enabled        => true,
        :manage_service => true,
        :ensure_package => 'latest',
      }
    end

    let :facts do
      { :osfamily => 'Debian' }
    end

    let :title do
      'foo'
    end
    it { is_expected.to contain_package('designate-foo').with(
      :name      => 'foo',
      :ensure    => 'latest',
      :tag       => ['openstack','designate-package'],
    )}

    it { is_expected.to contain_service('designate-foo').with(
      :name      => 'food',
      :ensure    => 'running',
      :enable    => true,
      :hasstatus => true,
      :tag       => ['openstack','designate-service'],
    )}

  end
end
