#
# Unit tests for designate::agent
#
require 'spec_helper'

describe 'designate::agent' do
  let :params do
    {
      :enabled => true
    }
  end

  shared_examples 'designate-agent' do
    context 'with default parameters' do
      it 'installs designate-agent package and service' do
        is_expected.to contain_service('designate-agent').with(
          :name      => platform_params[:agent_service_name],
          :ensure    => 'running',
          :enable    => 'true',
          :tag       => ['openstack', 'designate-service'],
        )
        is_expected.to contain_package('designate-agent').with(
          :name      => platform_params[:agent_package_name],
          :ensure    => 'present',
          :tag       => ['openstack', 'designate-package'],
        )
      end


      it 'configures designate-agent with default parameters' do
        is_expected.to contain_designate_config('service:agent/backend_driver').with_value('bind9')
        is_expected.to contain_designate_config('service:agent/listen').with_value('<SERVICE DEFAULT>')
      end

      context 'when using Power DNS backend driver' do
        before { params.merge!(:backend_driver => 'powerdns') }
        it 'configures designate-agent with pdns backend' do
          is_expected.to contain_designate_config('service:agent/backend_driver').with_value('powerdns')
        end
      end
    end

    context 'with custom package name' do
      before do
        params.merge!({ :agent_package_name => 'designate-agent-custom-name' })
      end

      it 'configures using custom name' do
        is_expected.to contain_package('designate-agent').with(
          :name      => 'designate-agent-custom-name',
          :ensure    => 'present',
          :tag       => ['openstack', 'designate-package'],
        )
      end
    end

    context 'with overriding parameters' do
      before do
        params.merge!({ :listen => '127.0.0.1:9002' })
      end

      it 'configures designate-agent with custom parameters' do
        is_expected.to contain_designate_config('service:agent/listen').with_value( params[:listen] )
      end
    end

  end

  on_supported_os({
    :supported_os => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts())
      end

      let(:platform_params) do
        case facts[:osfamily]
        when 'Debian'
          {
            :agent_package_name => 'designate-agent',
            :agent_service_name => 'designate-agent'
          }
        when 'RedHat'
          {
            :agent_package_name => 'openstack-designate-agent',
            :agent_service_name => 'designate-agent'
          }
        end
      end
      it_behaves_like 'designate-agent'
    end
  end
end
