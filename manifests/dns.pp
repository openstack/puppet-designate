# == Class designate::dns
#
# Configure dns for designate service
#
# == Parameters
#
# [*designatepath*]
#   (optional) Directory for maintaining designate's state
#   Defaults to $designate::params::designatepath
#
# [*designatefile*]
#   (optional) File for maintaining designate's state
#   Defaults to $designate::params::designatefile
#
class designate::dns (
  $designatepath  = $::designate::params::designatepath,
  $designatefile  = $::designate::params::designatefile,
) inherits designate::params {

  include ::dns::params
  file { $designatepath:
    ensure => directory,
    owner  => $::dns::params::user,
    group  => $::dns::params::group,
    mode   => '0770',
  }

  exec { 'create-designatefile':
    command => "/bin/touch ${designatefile}",
    creates => $designatefile,
    require => File[$designatepath],
  }

  file { $designatefile:
    owner   => $::dns::params::user,
    group   => $::dns::params::group,
    mode    => '0660',
    require => Exec['create-designatefile'],
  }

  file_line {'dns designate path':
    path    => $::dns::params::namedconf_path,
    line    => "include  \"${designatefile}\";",
    match   => '^include  \"(.*)$',
    require => Class['::designate'],
  }

}
