require 'spec_helper'

describe 'designate::sink::neutron_floatingip' do
  shared_examples 'designate::sink::neutron_floatingip' do
    context 'with default parameters' do
      it 'should confiure neutron notification handler options' do
        is_expected.to contain_designate_config('handler:neutron_floatingip/notification_topics').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_designate_config('handler:neutron_floatingip/control_exchange').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_designate_config('handler:neutron_floatingip/zone_id').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_designate_config('handler:neutron_floatingip/formatv4').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_designate_config('handler:neutron_floatingip/formatv6').with_value('<SERVICE DEFAULT>')
      end
    end

    context 'with overridden parameters' do
      let :params do
        {
          :notification_topics => 'notifications',
          :control_exchange    => 'neutron',
          :zone_id             => 'ZONEID',
          :formatv4            => 'v4format',
          :formatv6            => 'v6format',
        }
      end
      it 'should confiure neutron notification handler options' do
        is_expected.to contain_designate_config('handler:neutron_floatingip/notification_topics').with_value('notifications')
        is_expected.to contain_designate_config('handler:neutron_floatingip/control_exchange').with_value('neutron')
        is_expected.to contain_designate_config('handler:neutron_floatingip/zone_id').with_value('ZONEID')
        is_expected.to contain_designate_config('handler:neutron_floatingip/formatv4').with_value('v4format')
        is_expected.to contain_designate_config('handler:neutron_floatingip/formatv6').with_value('v6format')
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

      it_behaves_like 'designate::sink::neutron_floatingip'
    end
  end

end
