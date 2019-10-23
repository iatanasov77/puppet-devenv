class devenv::apache
{
	# Install and setup an Apache server with mod_php
	class { 'apache':
		default_vhost 	=> false,
		default_mods	=> false,
		mpm_module 		=> 'prefork',
	}
    
	# Apache modules
	each( $facts['apache_modules'] ) |$value| {
        class { "apache::mod::$value": }
    }
    
    class { 'apache::mod::php': 
        php_version => $phpVersion,
    }
}
