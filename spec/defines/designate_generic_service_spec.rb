require 'spec_helper'

describe 'designate::generic_service' do
  shared_examples_for 'designate::generic_service' do
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

    let :title do
      'foo'
    end

    context 'should configure related package and service' do
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

  on_supported_os({
    :supported_os => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts())
      end

      it_behaves_like 'designate::generic_service'
    end
  end

end
