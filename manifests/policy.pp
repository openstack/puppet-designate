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
#       'create_domain' => {
#         'key' => 'create_domain',
#         'value' => 'rule:admin'
#       },
#       'delete_domain' => {
#         'key' => 'default',
#         'value' => 'rule:admin'
#       }
#     }
#   Defaults to empty hash.
#
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

  validate_hash($policies)

  Openstacklib::Policy::Base {
    file_path => $policy_path,
  }

  create_resources('openstacklib::policy::base', $policies)

}
