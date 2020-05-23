
class devenv::xdebug::params
{
	case $operatingsystem 
	{
		'RedHat', 'CentOS', 'Fedora': 
		{
			$original_ini_file_path	= '/etc/php.d/15-xdebug.ini'
			$ini_file_path = '/etc/php.d/xdebug.ini'
			$package = 'php-pecl-xdebug'
			$php = 'php-cli'
			$zend_extension_module = 'xdebug.so'
		}
		'Debian', 'Ubuntu':
		{
			$original_ini_file_path	= '/etc/php.d/15-xdebug.ini'
			$ini_file_path = "/etc/php/${vsConfig['phpVersion']}/mods-available/xdebug.ini"
			$package = 'php-xdebug'
			$php = "php${vsConfig['phpVersion']}"
			$zend_extension_module = 'xdebug.so'
		}
	}

	$default_enable      = '1'
	$remote_enable       = '1'
	$remote_handler      = 'dbgp'
	$remote_host         = 'localhost'
	$remote_port         = '9000'
	$remote_autostart    = '0'
	$remote_connect_back = '1'
	$remote_log          = false
	$idekey              = ''
	
	# Tracer default settings
	$trace_format           = '1'
    $trace_enable_trigger   = '1'
    $trace_output_name      = 'trace.out'
    $trace_output_dir       = '/home/nickname/Xdebug'
    
    # Profiler default settings
    $profiler_enable        = '0'
    $profiler_enable_trigger= '1'
    $profiler_output_name   = 'cachegrind.out'
    $profiler_output_dir    = '/home/nickname/Xdebug'
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
	
    $trace_format           = $devenv::xdebug::params::trace_format,
    $trace_enable_trigger   = $devenv::xdebug::params::trace_enable_trigger,
    $trace_output_name      = $devenv::xdebug::params::trace_output_name,
    $trace_output_dir       = $devenv::xdebug::params::trace_output_dir,
    
    $profiler_enable        = $devenv::xdebug::params::profiler_enable,
    $profiler_enable_trigger= $devenv::xdebug::params::profiler_enable_trigger,
    $profiler_output_name   = $devenv::xdebug::params::profiler_output_name,
    $profiler_output_dir    = $devenv::xdebug::params::profiler_output_dir,
) inherits devenv::xdebug::params 
{
	$zend_extension_module = $devenv::xdebug::params::zend_extension_module

	package { "$devenv::xdebug::params::package":
		ensure	=> "installed",
		require => Package[$devenv::xdebug::params::php],
		notify	=> File[$ini_file_path],
		configfiles => "replace"
	}

	file { "$original_ini_file_path" :
		ensure  => absent,
		require => Package[$devenv::xdebug::params::package],
	} ->
	
	file { "$ini_file_path" :
		content => template('devenv/xdebug_ini.erb'),
		ensure  => present,
		require => Package[$devenv::xdebug::params::package],
		notify  => Service[$service],
	}
}
