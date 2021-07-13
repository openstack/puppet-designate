Puppet::Type.type(:designate_config).provide(
  :openstackconfig,
  :parent => Puppet::Type.type(:openstack_config).provider(:ruby)
) do

  def self.file_path
    '/etc/designate/designate.conf'
  end

end
