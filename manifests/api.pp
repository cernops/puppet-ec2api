# === Parameters
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
	$keystone_url						= 'http://localhost:5000/v2.0',
	$keystone_ec2_tokens_url			= 'http://localhost:5000/v2.0/ec2tokens',
	$ec2_timestamp_expiry				= 300,
	$api_rate_limit						= false,
	$use_forwarded_for					= false,
	$internal_service_availability_zone	= internal,
	$my_ip								= '10.0.0.1',
	$ec2_host							= $my_ip,
	$ec2_port							= 8788,
	$ec2_scheme							= 'http',
	$ec2_path							= '/',
	$region_list						= undef,
	$full_vpc_support					= true,
	$network_device_mtu					= 1500,
	$cert_topic							= 'cert',
	$image_decryption_dir				= '/tmp',
	$s3_host							= '10.0.0.1',
	$s3_use_ssl							= false,
	$s3_affix_tenant					= false,
	$ec2_private_dns_show_ip			= false,
	$external_network					= undef,
	$keystone_auth_uri					= 'http://localhost:5000/',
	$identity_uri						= 'http://localhost:35357/',
	$auth_version						= 'v2.0',
	$keystone_admin_user				= 'ec2api',
	$keystone_admin_tenant				= 'services',
	$keystone_admin_password			= undef,
	$keystone_certfile					= undef,
	$keystone_keyfile					= undef,
	$keystone_cafile					= undef,
	$insecure							= false,
	$signing_dir						= undef,
	$memcached_servers					= undef,
) {
		# Set values to ec2api.conf file
	ec2api_config {
		'DEFAULT/keystone_url':							value => $keystone_url;
		'DEFAULT/keystone_ec2_tokens_url':				value => $keystone_ec2_tokens_url;
		'DEFAULT/ec2_timestamp_expiry':					value => $ec2_timestamp_expiry;
		'DEFAULT/api_rate_limit':						value => $api_rate_limit;
		'DEFAULT/use_forwarded_for':					value => $use_forwarded_for;
		'DEFAULT/internal_service_availability_zone':	value => $internal_service_availability_zone;
		'DEFAULT/my_ip':								value => $my_ip;
		'DEFAULT/ec2_host':								value => $ec2_host;
		'DEFAULT/ec2_port':								value => $ec2_port;
		'DEFAULT/ec2_scheme':							value => $ec2_scheme;
		'DEFAULT/ec2_path':								value => $ec2_path;
		'DEFAULT/region_list':							value => $region_list;
		'DEFAULT/full_vpc_support':						value => $full_vpc_support;
		'DEFAULT/network_device_mtu':					value => $network_device_mtu;
		'DEFAULT/cert_topic':							value => $cert_topic;
		'DEFAULT/image_decryption_dir':					value => $image_decryption_dir;
		'DEFAULT/s3_host':								value => $s3_host;
		'DEFAULT/s3_use_ssl':							value => $s3_use_ssl;
		'DEFAULT/s3_affix_tenant':						value => $s3_affix_tenant;
		'DEFAULT/ec2_private_dns_show_ip':				value => ec2_private_dns_show_ip;
		'DEFAULT/external_network':						value => $external_network;
		'keystone_auth_uri/auth_uri':					value => $keystone_auth_uri;
		'keystone_auth_uri/identity_uri':				value => $identity_uri;
		'keystone_auth_uri/auth_version':				value => $auth_version;
		'keystone_auth_uri/admin_user':					value => $keystone_admin_user;
		'keystone_auth_uri/admin_tenant':				value => $keystone_admin_tenant;
		'keystone_auth_uri/admin_password':				value => $keystone_admin_password;
		'keystone_auth_uri/certfile':					value => $keystone_certfile;
		'keystone_auth_uri/keyfile':					value => $keystone_keyfile;
		'keystone_auth_uri/cafile':						value => $keystone_cafile;
		'keystone_auth_uri/insecure':					value => $insecure;
		'DEFAULT/signing_dir':							value => $signing_dir;
		'DEFAULT/memcached_servers':					value => $memcached_servers;
	}
}