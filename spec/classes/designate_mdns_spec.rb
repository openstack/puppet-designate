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

      it 'includes designate::db' do
        is_expected.to contain_class('designate::db')
      end

      it 'configures designate-mdns with default parameters' do
        is_expected.to contain_designate_config('service:mdns/workers').with_value(8)
        is_expected.to contain_designate_config('service:mdns/threads').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_designate_config('service:mdns/tcp_backlog').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_designate_config('service:mdns/tcp_recv_timeout').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_designate_config('service:mdns/all_tcp').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_designate_config('service:mdns/query_enforce_tsig').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_designate_config('service:mdns/storage_driver').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_designate_config('service:mdns/max_message_size').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_designate_config('service:mdns/listen').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_designate_config('service:mdns/topic').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_designate_config('service:mdns/xfr_timeout').with_value('<SERVICE DEFAULT>')
      end

      context 'when using custom options' do
        before do
          params.merge!({
            :workers            => 2,
            :threads            => 4,
            :tcp_backlog        => 100,
            :tcp_recv_timeout   => 0.5,
            :all_tcp            => false,
            :query_enforce_tsig => true,
            :storage_driver     => 'sqlalchemy',
            :max_message_size   => 65535,
            :listen             => ['192.0.2.10:5354', '192.0.2.20:5354'],
            :topic              => 'mdns',
            :xfr_timeout        => 10,
          })
        end
        it 'configures designate-mdns with custom options ' do
          is_expected.to contain_designate_config('service:mdns/workers').with_value(2)
          is_expected.to contain_designate_config('service:mdns/threads').with_value(4)
          is_expected.to contain_designate_config('service:mdns/tcp_backlog').with_value(100)
          is_expected.to contain_designate_config('service:mdns/tcp_recv_timeout').with_value(0.5)
          is_expected.to contain_designate_config('service:mdns/all_tcp').with_value(false)
          is_expected.to contain_designate_config('service:mdns/query_enforce_tsig').with_value(true)
          is_expected.to contain_designate_config('service:mdns/storage_driver').with_value('sqlalchemy')
          is_expected.to contain_designate_config('service:mdns/max_message_size').with_value(65535)
          is_expected.to contain_designate_config('service:mdns/listen').with_value('192.0.2.10:5354,192.0.2.20:5354')
          is_expected.to contain_designate_config('service:mdns/topic').with_value('mdns')
          is_expected.to contain_designate_config('service:mdns/xfr_timeout').with_value(10)
        end
      end
    end
  end

  on_supported_os({
    :supported_os => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts({ :os_workers => 8 }))
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
            :mdns_service_name => 'designate-mdns'
          }
        end
      end
      it_behaves_like 'designate-mdns'
    end
  end
end
