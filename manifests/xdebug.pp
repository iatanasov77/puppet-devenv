
class devenv::xdebug::params
{
	case $operatingsystem 
	{
		'RedHat', 'CentOS', 'Fedora': 
		{
			$ini_file_path = '/etc/php.d/15-xdebug.ini'
			$package = 'php-pecl-xdebug'
			$php = 'php-cli'
			$zend_extension_module = 'xdebug.so'
		}
		'Debian', 'Ubuntu':
		{
			$ini_file_path = '/etc/php/7.1/mods-available/xdebug.ini'
			$package = 'php-xdebug'
			$php = 'php-cli'
			$zend_extension_module = 'xdebug.so'
		}
	}

	$default_enable      = '1'
	$remote_enable       = '1'
	$remote_handler      = 'dbgp'
	$remote_host         = 'localhost'
	$remote_port         = '9000'
	$remote_autostart    = '1'
	$remote_connect_back = '0'
	$remote_log          = false
	$idekey              = ''
}

class devenv::xdebug (
	$service              = "httpd",
	$ini_file_path        = $devenv::xdebug::params::ini_file_path,
	$default_enable       = $devenv::xdebug::params::default_enable,
	$remote_enable        = $devenv::xdebug::params::remote_enable,
	$remote_handler       = $devenv::xdebug::params::remote_handler,
	$remote_host          = $devenv::xdebug::params::remote_host,
	$remote_port          = $devenv::xdebug::params::remote_port,
	$remote_autostart     = $devenv::xdebug::params::remote_autostart,
	$remote_connect_back  = $devenv::xdebug::params::remote_connect_back,
	$remote_log           = $devenv::xdebug::params::remote_log,
	$idekey               = $devenv::xdebug::params::idekey,
) inherits devenv::xdebug::params 
{
	$zend_extension_module = $devenv::xdebug::params::zend_extension_module

	package { "$devenv::xdebug::params::package":
		ensure	=> "installed",
		require => Package[$devenv::xdebug::params::php],
		notify	=> File[$ini_file_path],
	}

	file { "$ini_file_path" :
		content => template('devenv/xdebug_ini.erb'),
		ensure  => present,
		require => Package[$devenv::xdebug::params::package],
		notify  => Service[$service],
	}
}
