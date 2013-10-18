# Configure dns for designate service

class designate::dns (
  $designatepath  = $designate::params::designatepath,
  $designatefile  = $designate::params::designatefile,
){

  include dns::params
  file { $designatepath:
    ensure  => directory,
    owner   => 'named',
    group   => $dns::params::group,
    mode    => '0770',
  }

  exec { 'create-designatefile':
    command => "/bin/touch ${designatefile}",
    creates => $designatefile,
    require => File[$designatepath],
  }

  file { $designatefile:
    owner   => 'named',
    group   => $dns::params::group,
    mode    => '0660',
    require => Exec['create-designatefile'],
  }

}
