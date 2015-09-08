# == Class: ec2api
#
# Main EC2 API class to configure the service via puppet.
#
# === Parameters
#
# [*debug*]
#   Print debugging output (set logging level to DEBUG instead of default WARNING
#   level). Defaults to false
#
# [*verbose*]
#   Print more verbose output (set logging level to INFO instead of default
#   WARNING level). Defaults to false
#
# [*admin_user*]
#	The user does not need admin credentials into the project
#   Admin use. Defaults to undef
#
# [*admin_password*]
#	Admin password. Defaults to undef
#
# [*admin_tenant_name*]
#	Admin tenant name. Defaults to undef
#
# [*api_paste_config*]
#	File name for the paste.deploy config for ec2api (string
#   value). Defaults to 'api-paste.ini'
#
# [*log_file*]
#	(optional) File where logs should be stored.
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
class ec2api (
	$debug							= false,
	$verbose						= false,
	$admin_user						= undef,
	$admin_password					= undef,
	$admin_tenant_name				= undef,
	$fatal_exception_format_errors	= false,
	$ec2api_listen					= '0.0.0.0',
	$ec2api_listen_port				= 8788,
	$ec2api_use_ssl					= false,
	$ec2api_workers					= undef,
	$metadata_listen				= '0.0.0.0',
	$metadata_listen_port			= 8789,
	$metadata_use_ssl				= false,
	$metadata_workers				= undef,
	$service_down_time				= 60,
	$api_paste_config				= 'api-paste.ini',
	$log_dir						= '/var/log/ec2api',
	$use_ssl 						= false,
	$wsgi_ssl_ca_file				= undef,
	$wsgi_ssl_cert_file				= undef,
	$wsgi_ssl_key_file				= undef,
	$database_use_tpool				= false,
	$database_connection			= 'sqlite:////var/lib/ec2api/ec2api.sqlite',
) {

	include ec2api::params

	Package['ec2api'] -> Ec2api_config<||>
  	Package['ec2api'] -> Ec2api_api_paste_ini<||>

	if $use_ssl {
    	if !$cert_file {
      		fail('The cert_file parameter is required when use_ssl is set to true')
    	}
    	if !$key_file {
      		fail('The key_file parameter is required when use_ssl is set to true')
    	}
  	}

  	# Install the package
	package { 'ec2api':
    	ensure  => present,
    	name    => $::ec2api::params::package_name,
  	}


  	# Chanage onwer, group and permissions to config files
  	file { $::ec2api::params::ec2api_conf:
	    ensure  => present,
	    owner   => 'ec2api',
	    group   => 'ec2api',
	    mode    => '0644',
    	require => Package['ec2api'],
  	}

  	file { $::ec2api::params::ec2api_paste_api_ini:
	    ensure  => present,
	    owner   => 'ec2api',
	    group   => 'ec2api',
	    mode    => '0644',
	    require => Package['ec2api'],
	}

	# Set values to ec2api.conf file
	ec2api_config {
		'DEFAULT/debug':							value => $debug;
		'DEFAULT/verbose':							value => $verbose;
		'DEFAULT/admin_user':						value => $admin_user;
		'DEFAULT/admin_password':					value => $admin_password, secret => true;
		'DEFAULT/admin_tenant_name':				value => $admin_tenant_name;
		'DEFAULT/fatal_exception_format_errors':	value => $fatal_exception_format_errors;
		'DEFAULT/ec2api_listen':					value => $ec2api_listen;
		'DEFAULT/ec2api_listen_port':				value => $ec2api_listen_port;
		'DEFAULT/ec2api_use_ssl':					value => $ec2api_use_ssl;
		'DEFAULT/ec2api_workers':					value => $ec2api_workers;
		'DEFAULT/metadata_listen':					value => $metadata_listen;
		'DEFAULT/metadata_listen_port':				value => $metadata_listen_port;
		'DEFAULT/metadata_use_ssl':					value => $metadata_use_ssl;
		'DEFAULT/metadata_workers':					value => $metadata_workers;
		'DEFAULT/service_down_time':				value => $service_down_time;
		'DEFAULT/api_paste_config':					value => $api_paste_config;
		'database/use_tpool':						value => $database_use_tpool;
		'database/connection':						value => $database_connection;
	}

	# SSL Options
	if $use_ssl {
		ec2api_config {
			'DEFAULT/ssl_ca_file':						value => $wsgi_ssl_ca_file;
			'DEFAULT/ssl_cert_file':					value => $wsgi_ssl_cert_file;
			'DEFAULT/ssl_key_file':						value => $wsgi_ssl_key_file;
		}
		if $ca_file {
			ec2api_config { 
				'DEFAULT/ssl_ca_file' :	value => $ca_file,
			}
    	} else {
    		ec2api_config {
    			'DEFAULT/ssl_ca_file' :	ensure => absent,
      		}
    	}
	} else {
	    ec2api_config {
	      'DEFAULT/ssl_cert_file' : ensure => absent;
	      'DEFAULT/ssl_key_file' :  ensure => absent;
	      'DEFAULT/ssl_ca_file' :   ensure => absent;
	    }
  	}
}
