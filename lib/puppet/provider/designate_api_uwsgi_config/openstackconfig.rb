Puppet::Type.type(:designate_api_uwsgi_config).provide(
  :openstackconfig,
  :parent => Puppet::Type.type(:openstack_config).provider(:ruby)
) do

  def self.file_path
    '/etc/designate/designate-api-uwsgi.ini'
  end

end
