#
# Unit tests for designate::api
#
require 'spec_helper'

describe 'designate::api' do

  let :pre_condition do
    "class { 'designate::keystone::authtoken':
      password => 'a_big_secret',
    }"
  end

  let :params do
    {}
  end

  shared_examples 'designate-api' do
    context 'with default parameters' do
      it 'includes the dependent classes' do
        is_expected.to contain_class('designate::deps')
        is_expected.to contain_class('designate::policy')
      end

      it 'installs designate-api package and service' do
        is_expected.to contain_service('designate-api').with(
          :name      => platform_params[:api_service_name],
          :ensure    => 'running',
          :enable    => 'true',
          :tag       => ['openstack', 'designate-service'],
        )
        is_expected.to contain_package('designate-api').with(
          :name      => platform_params[:api_package_name],
          :ensure    => 'present',
          :tag       => ['openstack', 'designate-package'],
        )
      end

      it 'configures designate-api with default parameters' do
        is_expected.to contain_designate_config('service:api/auth_strategy').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_designate_config('service:api/enable_api_v2').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_designate_config('service:api/enable_api_admin').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_designate_config('service:api/api_base_uri').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_designate_config('service:api/listen').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_designate_config('service:api/workers').with_value(8)
        is_expected.to contain_designate_config('service:api/threads').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_designate_config('service:api/enable_host_header').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_designate_config('DEFAULT/max_header_line').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_designate_config('service:api/default_limit_admin').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_designate_config('service:api/max_limit_admin').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_designate_config('service:api/default_limit_v2').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_designate_config('service:api/max_limit_v2').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_designate_config('service:api/pecan_debug').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_designate_config('service:api/enabled_extensions_v2').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_designate_config('service:api/enabled_extensions_admin').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_designate_config('service:api/quotas_verify_project_id').with_value('<SERVICE DEFAULT>')
        is_expected.to_not contain_designate__keystone__authtoken('designate_config')
        is_expected.to contain_oslo__middleware('designate_config').with(
          :enable_proxy_headers_parsing => '<SERVICE DEFAULT>'
        )
      end
    end

    context 'when overriding parameters' do
      before do
        params.merge!({
          :auth_strategy                 => 'noauth',
          :enable_api_v2                 => true,
          :enable_api_admin              => true,
          :api_base_uri                  => 'http://myhost.es:9001/',
          :listen                        => '0.0.0.0:9001',
          :workers                       => '10',
          :threads                       => '1500',
          :enable_host_header            => true,
          :max_header_line               => '17777',
          :default_limit_admin           => '25',
          :max_limit_admin               => '1500',
          :default_limit_v2              => '25',
          :max_limit_v2                  => '1500',
          :pecan_debug                   => true,
          :enabled_extensions_v2         => 'ext1,ext2',
          :enabled_extensions_admin      => 'reports,quotas,zones',
          :quotas_verify_project_id      => false,
          :enable_proxy_headers_parsing  => true,
        })
      end

      it 'configure service_api' do
        is_expected.to contain_designate_config('service:api/auth_strategy').with_value(params[:auth_strategy])
        is_expected.to contain_designate_config('service:api/enable_api_v2').with_value(params[:enable_api_v2])
        is_expected.to contain_designate_config('service:api/enable_api_admin').with_value(params[:enable_api_admin])
        is_expected.to contain_designate_config('service:api/api_base_uri').with_value(params[:api_base_uri])
        is_expected.to contain_designate_config('service:api/listen').with_value(params[:listen])
        is_expected.to contain_designate_config('service:api/workers').with_value(params[:workers])
        is_expected.to contain_designate_config('service:api/threads').with_value(params[:threads])
        is_expected.to contain_designate_config('service:api/enable_host_header').with_value(params[:enable_host_header])
        is_expected.to contain_designate_config('DEFAULT/max_header_line').with_value(params[:max_header_line])
        is_expected.to contain_designate_config('service:api/default_limit_admin').with_value(params[:default_limit_admin])
        is_expected.to contain_designate_config('service:api/max_limit_admin').with_value(params[:max_limit_admin])
        is_expected.to contain_designate_config('service:api/default_limit_v2').with_value(params[:default_limit_v2])
        is_expected.to contain_designate_config('service:api/max_limit_v2').with_value(params[:max_limit_v2])
        is_expected.to contain_designate_config('service:api/pecan_debug').with_value(params[:pecan_debug])
        is_expected.to contain_designate_config('service:api/enabled_extensions_v2').with_value(params[:enabled_extensions_v2])
        is_expected.to contain_designate_config('service:api/enabled_extensions_admin').with_value(params[:enabled_extensions_admin])
        is_expected.to contain_designate_config('service:api/quotas_verify_project_id').with_value(false)
        is_expected.to contain_oslo__middleware('designate_config').with(
          :enable_proxy_headers_parsing => params[:enable_proxy_headers_parsing]
        )
      end
    end

    context 'with enabled_extensions in list' do
      before do
        params.merge!({
          :enabled_extensions_v2    => ['ext1', 'ext2'],
          :enabled_extensions_admin => ['reports', 'quotas', 'zones']
        })
      end

      it 'configure service_api' do
        is_expected.to contain_designate_config('service:api/enabled_extensions_v2').with_value('ext1,ext2')
        is_expected.to contain_designate_config('service:api/enabled_extensions_admin').with_value('reports,quotas,zones')
      end
    end

    context 'with custom package name' do
      before do
        params.merge!({ :api_package_name => 'designate-api-custom-name' })
      end

      it 'configures using custom name' do
        is_expected.to contain_package('designate-api').with(
          :name      => 'designate-api-custom-name',
          :ensure    => 'present',
          :tag       => ['openstack', 'designate-package'],
        )
      end
    end
  end

  shared_examples 'designate-api wsgi' do
    let :pre_condition do
      "class { 'designate': }
       include ::designate::db
       class { '::designate::keystone::authtoken':
         password => 'password',
       }
       include ::apache
       "
    end

    let :params do
      {
        :service_name => 'httpd',
      }
    end

    context 'with required params' do
      it { should contain_package('designate-api').with(
        :ensure => 'present',
        :name   => platform_params[:api_package_name],
        :tag    => ['openstack', 'designate-package'],
      )}

      it { should contain_service('designate-api').with(
        :ensure => 'stopped',
        :name   => platform_params[:api_service_name],
        :enable => false,
        :tag    => ['designate-service']
      )}
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
        case facts[:os]['family']
        when 'Debian'
          {
            :api_package_name => 'designate-api',
            :api_service_name => 'designate-api'
          }
        when 'RedHat'
          {
            :api_package_name => 'openstack-designate-api',
            :api_service_name => 'designate-api'
          }
        end
      end
      it_behaves_like 'designate-api'
      it_behaves_like 'designate-api wsgi'
    end
  end
end
