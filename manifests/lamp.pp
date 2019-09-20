class devenv::lamp
{
	#include devenv::apache

	#include devenv::mysql
	
    class { 'devenv::php': }
  
	#class { 'phpmyadmin': }
	#phpmyadmin::server{ 'default': }

	# Setup default main virtual host
	/*
	apache::vhost { "${hostname}":
		port    	=> '80',
		docroot 	=> "${documentroot}", 
		override	=> 'all',
		#php_values 		=> ['memory_limit 1024M'],
		
		directories => [
			{
				'path'		=> "${documentroot}",
				'override'	=> 'All',
				'Require'	=> 'all granted' ,
			},
			{
				'path'		=> '/usr/share/phpmyadmin',
				'Require'	=> 'all granted' ,
			}
		],
		
		aliases		=> [
			{
				alias => '/phpMyAdmin',
				path  => '/usr/share/phpmyadmin'
			}, 
			{
				alias => '/phpmyadmin',
				path  => '/usr/share/phpmyadmin'
			}
		],
	}
	*/
}
