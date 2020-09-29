class devenv::vhosts
{
	# Setup default main virtual host
	apache::vhost { "${hostname}":
		port    	=> '80',
		
		serveraliases => [
            "www.${hostname}",
        ],
        serveradmin => "webmaster@${hostname}",
            
		docroot 	=> '/vagrant/gui_symfony/public', 
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
				'path'		        => '/vagrant/gui_symfony/public',
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
	
        if ( $config['fpmSocket'] ) {
            $customFragment = "
                <Proxy \"unix:${config['fpmSocket']}|fcgi://php-fpm\">
                    ProxySet disablereuse=off
                </Proxy>
     
                <FilesMatch \.php$>
                    SetHandler proxy:fcgi://php-fpm
                </FilesMatch>
            "
        } elsif ( $config['dotnetCoreApp'] ) {
            $customFragment = "
                ProxyPreserveHost On
                ProxyPass / ${config['reverseProxy']}
                ProxyPassReverse / ${config['reverseProxy']}
            "
            if ( 'dotnet_core' in $vsConfig['subsystems'] ) {
                exec { "${config['dotnetCoreApp']}":
                    command     => "sudo dotnet run --urls \"http://*:${config['dotnetCoreAppHttpPort']};https://*:${config['dotnetCoreAppHttpsPort']}\" >/dev/null 2>&1 &",
                    cwd         => "${config['dotnetCoreAppPath']}"
                }
            }
        } else {
            $customFragment = ''
        }
        
        #########################################################################
        # New versions of Apache not allow underscore(_) in host name by default
        #########################################################################
        apache::vhost { "${host}":
        	port    	=> '80',
        	
        	serveraliases => [
                "www.${host}",
            ],
        	serveradmin => "webmaster@${host}",

        	docroot 	=> $config['documentRoot'], 
        	override	=> 'all',
        	
        	directories => [
                {
                    'path'              => $config['documentRoot'],
                    'allow_override'    => ['All'],
                    'Require'           => 'all granted',
                }
            ],
            
        	custom_fragment    => $customFragment,
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
