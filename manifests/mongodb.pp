class devenv::mongodb::params
{
	case $operatingsystem 
	{
		'RedHat', 'CentOS', 'Fedora': 
		{
			$package 		= 'php-pecl-mongodb'
			$php 			= 'php-cli'
			$service		= 'httpd'
		}
		'Debian', 'Ubuntu':
		{
			$package 		= 'php-mongodb'
			$php 			= 'php7.2'
			$service		= apache2
		}
		default: {
			fail("${::operatingsystem} not supported")
		}
	}
	
	$config = {
		#'enable_opcode_cache' => 1,
		#'shm_size'            => '128M',
	}
}

class devenv::mongodb (
	$config       	= $devenv::mongodb::params::config
) inherits devenv::mongodb::params {

	package { "$devenv::mongodb::params::package":
		ensure	=> "installed",
		require => Package[$devenv::mongodb::params::php],
	}
}
