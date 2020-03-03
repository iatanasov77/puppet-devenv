class devenv::vhosts
{
	# Setup default main virtual host
	apache::vhost { "${hostname}":
		port    	=> '80',
		docroot 	=> '/vagrant/public', 
		override	=> 'all',
		#php_values 		=> ['memory_limit 1024M'],
		
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
		
		directories => [
			{
				'path'		        => '/vagrant/public',
				'allow_override'    => ['All'],
				'Require'           => 'all granted',
			},
			{
				'path'              => '/usr/share/phpMyAdmin',
                'allow_override'    => ['All'],
                'Require'           => 'all granted',
			}
		],
	}
	
	# Create cache/log dir
	file { "/var/www/${hostname}":
	    ensure => 'directory',
	    owner  => 'apache',
	    group  => 'root',
	    mode   => '0777',
	}

	$vhosts	= parsejson( file( $vsConfig['vhostsJson'] ) )
	$vhosts.each |String $host, Hash $config| {
		apache::vhost { "${host}":
			port    	=> '80',
			docroot 	=> $config['documentRoot'], 
			override	=> 'all',
			
			directories => [
				{
					'path'		        => $config['documentRoot'],
					'allow_override'    => ['All'],
					'Require'           => 'all granted',
				}
			]
		}
		
		# Create cache dir
		file { "/var/www/${host}":
		    ensure => 'directory',
		    owner  => 'apache',
		    group  => 'root',
		    mode   => '0777',
		}
	}
}
