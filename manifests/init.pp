# == Class: ec2api
#
# Main EC2 API class to configure the service via puppet.
#
class ec2api {

  include ec2api::params

  # Install the package
  package { 'ec2api':
    ensure => present,
    name   => $ec2api::params::package_name,
  }


  # Chanage onwer, group and permissions to config files
  file { $ec2api::params::ec2api_config:
    ensure  => present,
    owner   => 'ec2api',
    group   => 'ec2api',
    mode    => '0644',
    require => Package['ec2api'],
  }

  file { $ec2api::params::ec2api_api_paste_ini:
    ensure  => present,
    owner   => 'ec2api',
    group   => 'ec2api',
    mode    => '0644',
    require => Package['ec2api'],
  }

}
