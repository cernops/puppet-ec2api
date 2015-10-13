# === Parameters
#
#
class ec2api::s3 (
  $manage_service = true,
  $enabled        = true,
  $buckets_path   = undef,
  $s3_listen      = '0.0.0.0',
  $s3_listen_port = 3334,
) inherits ec2api {

# Configuration
  ec2api_config {
    'DEFAULT/buckets_path':   value => $buckets_path;
    'DEFAULT/s3_listen':      value => $s3_listen;
    'DEFAULT/s3_listen_port': value => $s3_listen_port;
  }

  if $manage_service {
    if $enabled {
      $service_ensure = 'running'
    } else {
      $service_ensure = 'stopped'
    }
  }

  service { 'openstack-ec2-api-s3':
    ensure     => $service_ensure,
    name       => $::ec2api::params::s3_service_name,
    enable     => $enabled,
    hasstatus  => true,
    hasrestart => true,
  }
}