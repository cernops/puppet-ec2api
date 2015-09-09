# === Parameters
#
#
class ec2api::metadata (
  $nova_metadata_ip             = '127.0.0.1',
  $nova_metadata_port           = 8775,
  $nova_metadata_protocol       = 'http',
  $nova_metadata_insecure       = false,
  $auth_ca_cert                 = unset,
  $nova_client_cert             = unset,
  $nova_client_priv_key         = unset,
  $metadata_proxy_shared_secret = unset,
) {
}