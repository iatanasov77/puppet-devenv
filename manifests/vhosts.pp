class vs_devenv::vhosts (
    String $defaultHost,
    String $defaultDocumentRoot,
    Hash $vhosts                    = {},
    Boolean $dotnetCore             = false,
) {
    
	# Setup default main virtual host
	#######################################
	apache::vhost { "${defaultHost}":
		port    	=> '80',
		
		serveraliases => [
            "www.${defaultHost}",
        ],
        serveradmin => "webmaster@${defaultHost}",
            
		docroot 	=> '/vagrant/gui_symfony/public', 
		override	=> 'all',
		#php_values 		=> ['memory_limit 1024M'],
		log_level          => 'debug',
		
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
				'path'		        => "${defaultDocumentRoot}",
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
	file { "/var/www/${defaultHost}":
	    ensure => 'directory',
	    owner  => 'apache',
	    group  => 'root',
	    mode   => '0777',
	}

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
            if ( $dotnetCore ) {
                exec { "${config['dotnetCoreApp']}":
                    command     => "sudo dotnet run --urls \"http://*:${config['dotnetCoreAppHttpPort']};https://*:${config['dotnetCoreAppHttpsPort']}\" >/dev/null 2>&1 &",
                    cwd         => "${config['dotnetCoreAppPath']}"
                }
            }
        } else {
            $customFragment = ''
        }
        
        if $config['needRewriteRules'] == undef {
            $needRewriteRules   = false
        } else {
            $needRewriteRules   = $config['needRewriteRules']
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
                    'Require'       => 'all granted',
                    
                    path            => $config['documentRoot'],
                    allow_override  => ['All'],
                    
                    rewrites        => devenv::apache_rewrite_rules( Boolean( $needRewriteRules ) )
                }
            ],
            
        	custom_fragment    => $customFragment,
        	log_level          => 'debug',
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
