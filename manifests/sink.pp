# Designate sink

class designate::sink (
  $service_ensure = 'running',
  $enabled        = true,
) {
  include designate::params

  package { 'designate-sink':
    ensure => installed,
    name   => $::designate::params::sink_package_name,
  }

  Package['designate-sink'] -> Service['designate-sink']

  service { 'designate-sink':
    ensure     => $service_ensure,
    name       => $::designate::params::sink_service_name,
    enable     => $enabled,
    hasstatus  => true,
    hasrestart => true,
  }
}
