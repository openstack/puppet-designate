#
# Unit tests for designate::mdns
#
require 'spec_helper'

describe 'designate::mdns' do

  let :params do
    { :enabled => true }
  end

  shared_examples 'designate-mdns' do

    context 'with default parameters' do

      it 'installs designate-mdns package and service' do
        is_expected.to contain_service('designate-mdns').with(
          :name      => platform_params[:mdns_service_name],
          :ensure    => 'running',
          :enable    => 'true',
          :tag       => ['openstack', 'designate-service'],
        )
        is_expected.to contain_package('designate-mdns').with(
          :name      => platform_params[:mdns_package_name],
          :ensure    => 'present',
          :tag       => ['openstack', 'designate-package'],
        )
      end

      it 'configures designate-mdns with default parameters' do
        is_expected.to contain_designate_config('service:mdns/workers').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_designate_config('service:mdns/threads').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_designate_config('service:mdns/host').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_designate_config('service:mdns/port').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_designate_config('service:mdns/tcp_backlog').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_designate_config('service:mdns/tcp_recv_timeout').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_designate_config('service:mdns/query_enforce_tsig').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_designate_config('service:mdns/storage_driver').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_designate_config('service:mdns/max_message_size').with_value('<SERVICE DEFAULT>')
      end

      context 'when using custom options' do
        before { params.merge!(:workers => '2',
                               :query_enforce_tsig => 'true',
                               :tcp_backlog => '200',
                               :max_message_size => '1000'
                              )}
        it 'configures designate-mdns with custom options ' do
          is_expected.to contain_designate_config('service:mdns/workers').with_value('2')
          is_expected.to contain_designate_config('service:mdns/query_enforce_tsig').with_value(true)
          is_expected.to contain_designate_config('service:mdns/tcp_backlog').with_value('200')
          is_expected.to contain_designate_config('service:mdns/max_message_size').with_value('1000')
        end
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
            :mdns_package_name => 'designate-mdns',
            :mdns_service_name => 'designate-mdns'
          }
        when 'RedHat'
          {
            :mdns_package_name => 'openstack-designate-mdns',
            :mdns_service_name => 'openstack-designate-mdns'
          }
        end
      end
      it_behaves_like 'designate-mdns'
    end
  end
end
