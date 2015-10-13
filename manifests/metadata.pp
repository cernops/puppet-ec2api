# === Parameters
#
#
class ec2api::metadata (
  $manage_service               = true,
  $enabled                      = true,
  $nova_metadata_ip             = '127.0.0.1',
  $nova_metadata_port           = 8775,
  $nova_metadata_protocol       = 'http',
  $nova_metadata_insecure       = false,
  $auth_ca_cert                 = unset,
  $nova_client_cert             = unset,
  $nova_client_priv_key         = unset,
  $metadata_proxy_shared_secret = unset,
) inherits ec2api {

  if $manage_service {
    if $enabled {
      $service_ensure = 'running'
    } else {
      $service_ensure = 'stopped'
    }
  }

  service { 'openstack-ec2-api-metadata':
    ensure     => $service_ensure,
    name       => $::ec2api::params::metadata_service_name,
    enable     => $enabled,
    hasstatus  => true,
    hasrestart => true,
  }
}