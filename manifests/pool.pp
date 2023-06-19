# == Define: designate::pool
#
# Define a pool.
#
# === Parameters
#
# [*nameservers*]
#  (required) An array of UUID's of the nameservers in this pool
#
# [*targets*]
#  (required) An array of UUID's of the targets in this pool
#
# [*also_notifies*]
#  (optional) List of hostnames and port numbers to also notify on zone changes.
#  Defaults to []
#
define designate::pool(
  Array[String[1]] $nameservers,
  Array[String[1]] $targets,
  Array[String[1]] $also_notifies = [],
){

  warning('Support for pool-manager was deprecated.')

  include designate::deps

  designate_config {
    "pool:${name}/nameservers":   value => join($nameservers,',');
    "pool:${name}/targets":       value => join($targets,',');
    "pool:${name}/also-notifies": value => join($also_notifies,',');
  }
}
