
class devenv::phpapc::params
{
	case $operatingsystem 
	{
		'RedHat', 'CentOS', 'Fedora': 
		{
			$config_file	= '/etc/php.d/apc.ini'
			$package 		= 'php-pecl-apc'
			$php 			= 'php-cli'
			$service		= 'httpd'
		}
		'Debian', 'Ubuntu':
		{
			$config_file	= '/etc/php/7.1/mods-available/apc.ini'
			$package 		= 'php-apcu'
			$php 			= 'php7.1'
			$service		= apache2
		}
		default: {
			fail("${::operatingsystem} not supported")
		}
	}
	
	$config = {
		'enable_opcode_cache' => 1,
		'shm_size'            => '128M',
	}
}

class phpapc (
	$config       	= $devenv::phpapc::params::config
) inherits phpapc::params {

	
	package { "$devenv::phpapc::params::package":
		ensure	=> "installed",
		require => Package[$devenv::phpapc::params::php],
		notify	=> File[$devenv::phpapc::params::config_file],
	}

	file { "$devenv::phpapc::params::config_file" :
		content => template('devenv/phpapc_ini.erb'),
		ensure  => present,
		require => Package[$devenv::phpapc::params::package],
		notify  => Service[$devenv::phpapc::params::service],
	}
}
