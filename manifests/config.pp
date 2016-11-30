# == Class: designate::config
#
# This class is used to manage arbitrary designate configurations.
#
# === Parameters
#
# [*xxx_config*]
#   (optional) Allow configuration of arbitrary designate configurations.
#   The value is an hash of xxx_config resources. Example:
#   { 'DEFAULT/foo' => { value => 'fooValue'},
#     'DEFAULT/bar' => { value => 'barValue'}
#   }
#
#   In yaml format, Example:
#   xxx_config:
#     DEFAULT/foo:
#       value: fooValue
#     DEFAULT/bar:
#       value: barValue
#
# [*designate_config*]
#   (optional) Allow configuration of designate.conf configurations.
#
# [*api_paste_ini_config*]
#   (optional) Allow configuration of /etc/designate/api-paste.ini configurations.
#
#   NOTE: The configuration MUST NOT be already handled by this module
#   or Puppet catalog compilation will fail with duplicate resources.
#
# [*rootwrap_config*]
#   (optional) Allow configuration of /etc/designate/rootwrap.conf.
#
class designate::config (
  $designate_config     = {},
  $api_paste_ini_config = {},
  $rootwrap_config      = {},
) {

  include ::designate::deps

  validate_hash($designate_config)
  validate_hash($api_paste_ini_config)
  validate_hash($rootwrap_config)

  create_resources('designate_config', $designate_config)
  create_resources('designate_api_paste_ini', $api_paste_ini_config)
  create_resources('designate_rootwrap_config', $rootwrap_config)
}
