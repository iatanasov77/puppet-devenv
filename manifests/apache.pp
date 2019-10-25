class devenv::apache
{
	# Install and setup an Apache server with mod_php
	class { 'apache':
		default_vhost 	=> false,
		default_mods	=> false,
		mpm_module 		=> 'prefork',
	}
    
	# Apache modules
	$vsConfig['apacheModules'].each |Integer $index, String $value| {
        notice("${index} = ${value}")
        notice( "APACHE MODULE: ${value}" )
        class { "apache::mod::${value}": }
    }
    
    class {'::apache::mod::php':
        php_version  => '7.2',
        path         => 'modules/libphp7.2.so',
    }
}
