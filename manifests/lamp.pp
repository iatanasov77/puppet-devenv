class devenv::lamp
{
	include devenv::apache
	include devenv::mysql
    include devenv::php
    include devenv::phpextensions

    class { '::composer':
        command_name => 'composer',
        target_dir   => '/usr/bin',
        auto_update => true
    }

	class { 'phpmyadmin': }

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
				'path'              => "/usr/share/phpMyAdmin",
                'allow_override'    => ['All'],
                'Require'           => 'all granted' ,
			}
		],
		
		aliases		=> [
			{
				alias => '/phpMyAdmin',
				path  => '/usr/share/phpMyAdmin'
			}, 
			{
				alias => '/phpmyadmin',
				path  => '/usr/share/phpMyAdmin'
			}
		],
	}
}
