
describe 'designate::db::mysql' do

  let :pre_condition do
    'include mysql::server'
  end

  let :required_params do
    { :password => "qwerty" }
  end

  shared_examples_for 'designate-db-mysql' do
    context 'with only required parameters' do
      let :params do
        required_params
      end

      it { is_expected.to contain_openstacklib__db__mysql('designate').with(
        :user          => 'designate',
        :password_hash => '*AA1420F182E88B9E5F874F6FBE7459291E8F4601',
        :charset       => 'utf8'
      )}
    end

    context 'when overriding charset' do
      let :params do
        { :charset => 'latin1' }.merge(required_params)
      end

      it { is_expected.to contain_openstacklib__db__mysql('designate').with_charset(params[:charset]) }
    end
  end

  context 'on a RedHat osfamily' do
    let :facts do
      { :osfamily => 'RedHat' }
    end

    context 'with only required parameters' do
      let :params do
        required_params
      end

      it { is_expected.to contain_openstacklib__db__mysql('designate').with(
        :user          => 'designate',
        :password_hash => '*AA1420F182E88B9E5F874F6FBE7459291E8F4601',
        :charset       => 'utf8'
      )}
    end

    context 'when overriding charset' do
      let :params do
        { :charset => 'latin1' }.merge(required_params)
      end

      it { is_expected.to contain_openstacklib__db__mysql('designate').with_charset(params[:charset]) }
    end

    context 'overriding allowed_hosts param with array' do
      let :params do
        { :allowed_hosts  => ['127.0.0.1','%'] }.merge(required_params)
      end

      it { is_expected.to contain_openstacklib__db__mysql('designate').with_allowed_hosts(params[:allowed_hosts]) }
    end
  end

  on_supported_os({
    :supported_os => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts())
      end

      it_behaves_like 'designate-db-mysql'
    end
  end
end
