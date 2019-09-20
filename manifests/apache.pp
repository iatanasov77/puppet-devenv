class devenv::apache
{
	# Install and setup an Apache server with mod_php
	class { 'apache':
		default_vhost 	=> false,
		default_mods	=> false,
		mpm_module 		=> 'prefork',
	}
	
	# Apache modules
	class { 'apache::mod::expires': }
	class { 'apache::mod::headers': }
	class { 'apache::mod::rewrite': }
	class { 'apache::mod::vhost_alias': }
	
	/*
	class { 'apache::mod::php': 
		php_version	=> $phpVersion,
	}
	*/
}
