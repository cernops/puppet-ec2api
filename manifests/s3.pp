# === Parameters
#
#
class ec2api::s3 (
  $buckets_path   = undef,
  $s3_listen      = '0.0.0.0',
  $s3_listen_port = 3334,
) {
  ec2api_config {
    'DEFAULT/buckets_path':   value => $buckets_path;
    'DEFAULT/s3_listen':      value => $s3_listen;
    'DEFAULT/s3_listen_port': value => $s3_listen_port;
  }
}