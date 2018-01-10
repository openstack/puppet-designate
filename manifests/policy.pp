# == Class: designate::policy
#
# Configure the designate policies
#
# === Parameters
#
# [*policies*]
#   (optional) Set of policies to configure for designate
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
#   (optional) Path to the designate policy.json file
#   Defaults to /etc/designate/policy.json
#
class designate::policy (
  $policies    = {},
  $policy_path = '/etc/designate/policy.json',
) {

  include ::designate::deps
  include ::designate::params

  validate_hash($policies)

  Openstacklib::Policy::Base {
    file_path  => $policy_path,
    file_user  => 'root',
    file_group => $::designate::params::group,
  }

  create_resources('openstacklib::policy::base', $policies)

  oslo::policy { 'designate_config': policy_file => $policy_path }

}
