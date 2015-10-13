# == Class: ec2api::api
#
# EC2 API class to configure the API service via puppet.
#
# === Parameters
#
# [*debug*]
#   Print debugging output (set logging level to DEBUG instead of default
#   WARNING level). Defaults to false
#
# [*verbose*]
#   Print more verbose output (set logging level to INFO instead of default
#   WARNING level). Defaults to false
#
# [*admin_user*]
#  The user does not need admin credentials into the project
#   Admin use. Defaults to undef
#
# [*admin_password*]
#  Admin password. Defaults to undef
#
# [*admin_tenant_name*]
#  Admin tenant name. Defaults to undef
#
# [*api_paste_config*]
#  File name for the paste.deploy config for ec2api (string
#   value). Defaults to 'api-paste.ini'
#
# [*log_file*]
#  (optional) File where logs should be stored.
#   If set to boolean false, it will not log to any file.
#   Defaults to '/var/log/ec2api/ec2api.log'
#
# [*ca_file*]
#   (optional) CA certificate file to use to verify connecting clients
#   Defaults to false, not set
#
# [*cert_file*]
#   (optinal) Certificate file to use when starting API server securely
#   Defaults to false, not set
#
# [*key_file*]
#   (optional) Private key file to use when starting API server securely
#   Defaults to false, not set
#
# [*keystone_url*]
#   URL to get token from ec2 request. (string value).
#   Defaults to 'http://localhost:5000/v2.0'#
#
# [*keystone_ec2_tokens_url*]
#   URL to get token from ec2 request.(string value).
#   Defaults to '$keystone_url/ec2tokens'
#
class ec2api::api (
  $manage_service                 = true,
  $enabled                        = true,
  $debug                          = false,
  $verbose                        = false,
  $admin_user                     = undef,
  $admin_password                 = undef,
  $admin_tenant_name              = undef,
  $fatal_exception_format_errors  = false,
  $ec2api_listen                  = '0.0.0.0',
  $ec2api_listen_port             = 8788,
  $ec2api_use_ssl                 = false,
  $ec2api_workers                 = undef,
  $metadata_listen                = '0.0.0.0',
  $metadata_listen_port           = 8789,
  $metadata_use_ssl               = false,
  $metadata_workers               = undef,
  $service_down_time              = 60,
  $api_paste_config               = 'api-paste.ini',
  $log_dir                        = '/var/log/ec2api',
  $use_ssl                        = false,
  $wsgi_ssl_ca_file               = undef,
  $wsgi_ssl_cert_file             = undef,
  $wsgi_ssl_key_file              = undef,
  $database_use_tpool             = false,
  $database_connection            = 'sqlite:////var/lib/ec2api/ec2api.sqlite',
  $keystone_url                        = 'http://localhost:5000/v2.0',
  $keystone_ec2_tokens_url             = 'http://localhost:5000/v2.0/ec2tokens',
  $ec2_timestamp_expiry                = 300,
  $api_rate_limit                      = false,
  $use_forwarded_for                   = false,
  $internal_service_availability_zone  = internal,
  $my_ip                               = '10.0.0.1',
  $ec2_host                            = $my_ip,
  $ec2_port                            = 8788,
  $ec2_scheme                          = 'http',
  $ec2_path                            = '/',
  $region_list                         = undef,
  $full_vpc_support                    = true,
  $network_device_mtu                  = 1500,
  $cert_topic                          = 'cert',
  $image_decryption_dir                = '/tmp',
  $s3_host                             = '10.0.0.1',
  $s3_use_ssl                          = false,
  $s3_affix_tenant                     = false,
  $ec2_private_dns_show_ip             = false,
  $external_network                    = undef,
# [keystone_authtoken]
  $auth_admin_prefix                   = undef,
  $auth_host                           = '127.0.0.1',
  $auth_port                           = 35357,
  $auth_protocol                       = 'https',
  $auth_uri                            = 'http://localhost:5000/',
  $identity_uri                        = 'http://localhost:35357/',
  $auth_version                        = 'v2.0',
  $delay_auth_decision                 = false,
  $http_connect_timeout                = undef,
  $http_request_max_retries            = 3,
  $admin_token                         = undef,
  $keystone_admin_user                 = 'ec2api',
  $keystone_admin_tenant_name          = 'services',
  $keystone_admin_password             = undef,
  $keystone_certfile                   = undef,
  $keystone_keyfile                    = undef,
  $keystone_cafile                     = undef,
  $insecure                            = false,
  $signing_dir                         = undef,
  $memcached_servers                   = undef,
  $token_cache_time                    = 300,
  $revocation_cache_time               = 10,
  $memcache_security_strategy          = undef,
  $memcache_secret_key                 = undef,
  $include_service_catalog             = true,
  $enforce_token_bind                  = permissive,
  $check_revocations_for_cached        = false,
  $hash_algorithms                     = 'md5',
# [metadata]
  $nova_metadata_ip                    = '127.0.0.1',
  $nova_metadata_port                  = 8775,
  $nova_metadata_protocol              = 'http',
  $nova_metadata_insecure              = false,
  $auth_ca_cert                        = undef,
  $nova_client_cert                    = undef,
  $nova_client_priv_key                = undef,
  $metadata_proxy_shared_secret        = undef

) inherits ec2api {

  Package[$ec2api::params::package_name] -> Ec2api_config<||>
  Package[$ec2api::params::package_name] -> Ec2api_api_paste_ini<||>

  if $use_ssl {
    if !$wsgi_ssl_cert_file {
        fail("The wsgi_ssl_cert_file parameter is required when use_ssl is \
             set to true")
    }
    if !$wsgi_ssl_key_file {
        fail("The wsgi_ssl_key_file parameter is required when use_ssl is \
             set to true")
    }
  }

  # Set values to ec2api.conf file
  ec2api_config {
    'DEFAULT/debug':                         value => $debug;
    'DEFAULT/verbose':                       value => $verbose;
    'DEFAULT/admin_user':                    value => $admin_user;
    'DEFAULT/admin_password':
      value => $admin_password;
    'DEFAULT/admin_tenant_name':             value => $admin_tenant_name;
    'DEFAULT/fatal_exception_format_errors':
      value => $fatal_exception_format_errors;
    'DEFAULT/ec2api_listen':                 value => $ec2api_listen;
    'DEFAULT/ec2api_listen_port':            value => $ec2api_listen_port;
    'DEFAULT/ec2api_use_ssl':                value => $ec2api_use_ssl;
    'DEFAULT/ec2api_workers':                value => $ec2api_workers;
    'DEFAULT/metadata_listen':               value => $metadata_listen;
    'DEFAULT/metadata_listen_port':          value => $metadata_listen_port;
    'DEFAULT/metadata_use_ssl':              value => $metadata_use_ssl;
    'DEFAULT/metadata_workers':              value => $metadata_workers;
    'DEFAULT/service_down_time':             value => $service_down_time;
    'DEFAULT/api_paste_config':              value => $api_paste_config;
    'database/use_tpool':                    value => $database_use_tpool;
    'database/connection':                   value => $database_connection;
    'DEFAULT/keystone_url':                       value => $keystone_url;
    'DEFAULT/keystone_ec2_tokens_url':
      value => $keystone_ec2_tokens_url;
    'DEFAULT/ec2_timestamp_expiry':
      value => $ec2_timestamp_expiry;
    'DEFAULT/api_rate_limit':                     value => $api_rate_limit;
    'DEFAULT/use_forwarded_for':                  value => $use_forwarded_for;
    'DEFAULT/internal_service_availability_zone':
      value => $internal_service_availability_zone;
    'DEFAULT/my_ip':                              value => $my_ip;
    #'DEFAULT/ec2_host':                           value => $ec2_host;
    'DEFAULT/ec2_port':                           value => $ec2_port;
    'DEFAULT/ec2_scheme':                         value => $ec2_scheme;
    'DEFAULT/ec2_path':                           value => $ec2_path;
    'DEFAULT/region_list':                        value => $region_list;
    'DEFAULT/full_vpc_support':                   value => $full_vpc_support;
    'DEFAULT/network_device_mtu':                 value => $network_device_mtu;
    'DEFAULT/cert_topic':                         value => $cert_topic;
    'DEFAULT/image_decryption_dir':
      value => $image_decryption_dir;
    'DEFAULT/s3_host':                            value => $s3_host;
    'DEFAULT/s3_use_ssl':                         value => $s3_use_ssl;
    'DEFAULT/s3_affix_tenant':                    value => $s3_affix_tenant;
    'DEFAULT/ec2_private_dns_show_ip':
      value => $ec2_private_dns_show_ip;
    'DEFAULT/external_network':                   value => $external_network;
    'keystone_authtoken/auth_admin_prefix':       value => $auth_admin_prefix;
    'keystone_authtoken/auth_host':               value => $auth_host;
    'keystone_authtoken/auth_port':               value => $auth_port;
    'keystone_authtoken/auth_protocol':           value => $auth_protocol;
    'keystone_authtoken/auth_uri':                value => $auth_uri;
    'keystone_authtoken/identity_uri':            value => $identity_uri;
    'keystone_authtoken/auth_version':            value => $auth_version;
    'keystone_authtoken/delay_auth_decision':     value => $delay_auth_decision;
    'keystone_authtoken/http_connect_timeout':
      value => $http_connect_timeout;
    'keystone_authtoken/http_request_max_retries':
      value => $http_request_max_retries;
    'keystone_authtoken/admin_token':             value =>$admin_token;
    'keystone_authtoken/admin_user':              value => $keystone_admin_user;
    'keystone_authtoken/admin_tenant':
      value => $keystone_admin_tenant_name;
    'keystone_authtoken/admin_password':
      value => $keystone_admin_password;
    'keystone_authtoken/certfile':                value => $keystone_certfile;
    'keystone_authtoken/keyfile':                 value => $keystone_keyfile;
    'keystone_authtoken/cafile':                  value => $keystone_cafile;
    'keystone_authtoken/insecure':                value => $insecure;
    'keystone_authtoken/signing_dir':             value => $signing_dir;
    'keystone_authtoken/memcached_servers':       value => $memcached_servers;
    'keystone_authtoken/token_cache_time':        value => $token_cache_time;
    'keystone_authtoken/revocation_cache_time':
      value => $revocation_cache_time;
    'keystone_authtoken/memcache_security_strategy':
      value => $memcache_security_strategy;
    'keystone_authtoken/memcache_secret_key':
      value => $memcache_secret_key;
    'keystone_authtoken/include_service_catalog':
      value => $include_service_catalog;
    'keystone_authtoken/enforce_token_bind':       value => $enforce_token_bind;
    'keystone_authtoken/check_revocations_for_cached':
      value => $check_revocations_for_cached;
    'keystone_authtoken/hash_algorithms':          value => $hash_algorithms;
    'metadata/nova_metadata_ip':
      value => $nova_metadata_ip;
    'metadata/nova_metadata_port':
      value => $nova_metadata_port;
    'metadata/nova_metadata_protocol':
      value => $nova_metadata_protocol;
    'metadata/nova_metadata_insecure':
      value => $nova_metadata_insecure;
    'metadata/auth_ca_cert':
      value => $auth_ca_cert;
    'metadata/nova_client_cert':
      value => $nova_client_cert;
    'metadata/nova_client_priv_key':
      value => $nova_client_priv_key;
    'metadata/metadata_proxy_shared_secret':
      value => $metadata_proxy_shared_secret;
  }

  # SSL options
  if $use_ssl {
    ec2api_config {
      'DEFAULT/ssl_ca_file':   value => $wsgi_ssl_ca_file;
      'DEFAULT/ssl_cert_file': value => $wsgi_ssl_cert_file;
      'DEFAULT/ssl_key_file':  value => $wsgi_ssl_key_file;
    }
    if $wsgi_ssl_ca_file {
      ec2api_config {
        'DEFAULT/ssl_ca_file' : value => $wsgi_ssl_ca_file,
      }
    } else {
      ec2api_config {
        'DEFAULT/ssl_ca_file' : ensure => absent,
        }
    }
  } else {
    ec2api_config {
      'DEFAULT/ssl_cert_file' : ensure => absent;
      'DEFAULT/ssl_key_file' :  ensure => absent;
      'DEFAULT/ssl_ca_file' :   ensure => absent;
    }
  }

  if $manage_service {
    if $enabled {
      $service_ensure = 'running'
    } else {
      $service_ensure = 'stopped'
    }
  }

  service { 'ec2api-api-service':
    ensure     => $service_ensure,
    name       => $::ec2api::params::api_service_name,
    enable     => $enabled,
    hasstatus  => true,
    hasrestart => true,
  }
}
