# == Class: ec2api::config
#
# This class is used to manage arbitrary ec2api configurations.
#
# === Parameters
#
# [*ec2api_config*]
#   (optional) Allow configuration of arbitrary ec2api configurations.
#   The value is an hash of ec2api_config resources. Example:
#   { 'DEFAULT/foo' => { value => 'fooValue'},
#     'DEFAULT/bar' => { value => 'barValue'}
#   }
#   In yaml format, Example:
#   ec2api_config:
#     DEFAULT/foo:
#       value: fooValue
#     DEFAULT/bar:
#       value: barValue
#
# [**ec2api_config**]
#   (optional) Allow configuration of ec2api.conf configurations.
# 
# [**api_paste_ini_config**]
#   (optional) Allow configuration of /etc/ec2api/api-paste.ini configurations.
#
#   NOTE: The configuration MUST NOT be already handled by this module
#   or Puppet catalog compilation will fail with duplicate resources.
#
class ec2api::config (
  $ec2api_config = {},
  $api_paste_ini_config = {},
) {

  validate_hash($ec2api_config)
  validate_hash($api_paste_ini_config)

  create_resources('ec2api_config', $ec2api_config)
  create_resources('ec2api_api_paste_ini', $api_paste_ini_config)
}
