# == Class: designate::policy
#
# Configure the designate policies
#
# === Parameters
#
# [*policies*]
#   (Optional) Set of policies to configure for designate
#   Example :
#     {
#       'designate-context_is_admin' => {
#         'key' => 'context_is_admin',
#         'value' => 'true'
#       },
#       'designate-default' => {
#         'key' => 'default',
#         'value' => 'rule:admin_or_owner'
#       }
#     }
#   Defaults to empty hash.
#
# [*policy_path*]
#   (Optional) Path to the designate policy.yaml file
#   Defaults to /etc/designate/policy.yaml
#
class designate::policy (
  $policies    = {},
  $policy_path = '/etc/designate/policy.yaml',
) {

  include designate::deps
  include designate::params

  validate_legacy(Hash, 'validate_hash', $policies)

  Openstacklib::Policy::Base {
    file_path   => $policy_path,
    file_user   => 'root',
    file_group  => $::designate::params::group,
    file_format => 'yaml',
  }

  create_resources('openstacklib::policy::base', $policies)

  oslo::policy { 'designate_config': policy_file => $policy_path }

}
