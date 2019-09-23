class devenv::lamp
{
	include devenv::apache

	include devenv::mysql
	
    class { 'devenv::php': }

    class { '::composer':
        command_name => 'composer',
        target_dir   => '/usr/bin',
        auto_update => true
    }

	class { 'phpmyadmin': }
	phpmyadmin::server{ 'default': }

	# Setup default main virtual host
	apache::vhost { "${hostname}":
		port    	=> '80',
		docroot 	=> "${documentroot}", 
		override	=> 'all',
		#php_values 		=> ['memory_limit 1024M'],
		
		directories => [
			{
				'path'		        => "${documentroot}",
				'allow_override'    => ['All'],
				'Require'           => 'all granted' ,
			},
			{
				'path'              => "/usr/share/phpmyadmin",
                'allow_override'    => ['All'],
                'Require'           => 'all granted' ,
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
}
