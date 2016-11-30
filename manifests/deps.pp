# == Class: designate::deps
#
#  Designate anchors and dependency management
#
class designate::deps {
  # Setup anchors for install, config and service phases of the module.  These
  # anchors allow external modules to hook the begin and end of any of these
  # phases.  Package or service management can also be replaced by ensuring the
  # package is absent or turning off service management and having the
  # replacement depend on the appropriate anchors.  When applicable, end tags
  # should be notified so that subscribers can determine if installation,
  # config or service state changed and act on that if needed.
  anchor { 'designate::install::begin': }
  -> Package<| tag == 'designate-package'|>
  ~> anchor { 'designate::install::end': }
  -> anchor { 'designate::config::begin': }
  -> Designate_config<||>
  ~> anchor { 'designate::config::end': }
  -> anchor { 'designate::db::begin': }
  -> anchor { 'designate::db::end': }
  ~> anchor { 'designate::dbsync::begin': }
  -> anchor { 'designate::dbsync::end': }
  ~> anchor { 'designate::service::begin': }
  ~> Service<| tag == 'designate-service' |>
  ~> anchor { 'designate::service::end': }

  # policy config should occur in the config block also.
  Anchor['designate::config::begin']
  -> Openstacklib::Policy::Base<||>
  ~> Anchor['designate::config::end']

  # Installation or config changes will always restart services.
  Anchor['designate::install::end'] ~> Anchor['designate::service::begin']
  Anchor['designate::config::end']  ~> Anchor['designate::service::begin']
}
