require 'spec_helper'

describe 'designate::sink::nova_fixed' do
  shared_examples 'designate::sink::nova_fixed' do
    context 'with default parameters' do
      it 'should confiure nova notification handler options' do
        is_expected.to contain_designate_config('handler:nova_fixed/notification_topics').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_designate_config('handler:nova_fixed/control_exchange').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_designate_config('handler:nova_fixed/zone_id').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_designate_config('handler:nova_fixed/formatv4').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_designate_config('handler:nova_fixed/formatv6').with_value('<SERVICE DEFAULT>')
      end
    end

    context 'with overridden parameters' do
      let :params do
        {
          :notification_topics => 'notifications',
          :control_exchange    => 'nova',
          :zone_id             => 'ZONEID',
          :formatv4            => 'v4format',
          :formatv6            => 'v6format',
        }
      end
      it 'should confiure nova notification handler options' do
        is_expected.to contain_designate_config('handler:nova_fixed/notification_topics').with_value('notifications')
        is_expected.to contain_designate_config('handler:nova_fixed/control_exchange').with_value('nova')
        is_expected.to contain_designate_config('handler:nova_fixed/zone_id').with_value('ZONEID')
        is_expected.to contain_designate_config('handler:nova_fixed/formatv4').with_value('v4format')
        is_expected.to contain_designate_config('handler:nova_fixed/formatv6').with_value('v6format')
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

      it_behaves_like 'designate::sink::nova_fixed'
    end
  end

end
