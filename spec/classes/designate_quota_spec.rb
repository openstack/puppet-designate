#
# Unit tests for designate::quota
#
require 'spec_helper'

describe 'designate::quota' do

  let :params do
    {}
  end

  shared_examples 'designate-quota' do

    context 'with default parameters' do

      it 'configures designate-quota with default parameters' do
        is_expected.to contain_designate_config('DEFAULT/quota_api_export_size').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_designate_config('DEFAULT/quota_zone_records').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_designate_config('DEFAULT/quota_zone_recordsets').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_designate_config('DEFAULT/quota_zones').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_designate_config('DEFAULT/quota_driver').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_designate_config('DEFAULT/quota_recordset_records').with_value('<SERVICE DEFAULT>')
      end

      context 'when using custom options' do
        before { params.merge!(:quota_api_export_size   => '20',
                               :quota_zone_records      => '20',
                               :quota_zone_recordsets   => '20',
                               :quota_zones             => '20',
                               :quota_driver            => 'dummy',
                               :quota_recordset_records => '20',
                              )}
        it 'configures designate-quota with custom options' do
          is_expected.to contain_designate_config('DEFAULT/quota_api_export_size').with_value('20')
          is_expected.to contain_designate_config('DEFAULT/quota_zone_records').with_value('20')
          is_expected.to contain_designate_config('DEFAULT/quota_zone_recordsets').with_value('20')
          is_expected.to contain_designate_config('DEFAULT/quota_zones').with_value('20')
          is_expected.to contain_designate_config('DEFAULT/quota_driver').with_value('dummy')
          is_expected.to contain_designate_config('DEFAULT/quota_recordset_records').with_value('20')
        end
      end
    end
  end
  on_supported_os({
    :supported_os   => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts())
      end

      it_behaves_like 'designate-quota'
    end
  end
end
