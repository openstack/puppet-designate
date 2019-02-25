# == Define: designate::pool
#
# Define a pool.
#
# === Parameters
#
# [*nameservers*]
#  An array of UUID's of the nameservers in this pool
#
# [*targets*]
#  An array of UUID's of the targets in this pool
#
# [*also_notifies*]
#  (optional) List of hostnames and port numbers to also notify on zone changes.
#
define designate::pool(
  $nameservers,
  $targets,
  $also_notifies = [],
){

  include ::designate::deps

  validate_legacy(Pattern[/[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}/],
    'validate_re', $name, ['[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}',
    'Pool name should be a UUID.'])

  validate_legacy(Array, 'validate_array', $nameservers)
  validate_legacy(Array, 'validate_array', $targets)
  validate_legacy(Array, 'validate_array', $also_notifies)

  designate_config {
    "pool:${name}/nameservers":   value => join($nameservers,',');
    "pool:${name}/targets":       value => join($targets,',');
    "pool:${name}/also-notifies": value => join($also_notifies,',');
  }
}
