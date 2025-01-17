class vs_devenv::subsystems::cassandra::phpDriver (
	String $version,
	Boolean $installDriver				= true,
	Boolean $installDriverFromGitHub	= false,
) {
	case $::operatingsystem {
    	#centos: {
    	'RedHat', 'CentOS', 'OracleLinux', 'Fedora', 'AlmaLinux': {
			if $::operatingsystemmajrelease == '7' {
				$dependencies			= {
					'libuv'			=> 'https://downloads.datastax.com/cpp-driver/centos/7/dependencies/libuv/v1.35.0/libuv-1.35.0-1.el7.x86_64.rpm',
					'libuv-devel'	=> 'https://downloads.datastax.com/cpp-driver/centos/7/dependencies/libuv/v1.35.0/libuv-devel-1.35.0-1.el7.x86_64.rpm'
				}
				
				$supportedVersions		= ['2.11.0', '2.12.0', '2.13.0', '2.14.0', '2.14.1', '2.15.0', '2.15.1', '2.15.2', '2.15.3', '2.16.0']
				$cassaDriverSource		= "http://downloads.datastax.com/cpp-driver/centos/7/cassandra/v${version}/cassandra-cpp-driver-${version}-1.el7.x86_64.rpm"
				$cassaDriverDevelSource	= "http://downloads.datastax.com/cpp-driver/centos/7/cassandra/v${version}/cassandra-cpp-driver-devel-${version}-1.el7.x86_64.rpm"
			} elsif Integer( $::operatingsystemmajrelease ) >= 8 {
				$dependencies			= {
					'libuv'			=> 'https://downloads.datastax.com/cpp-driver/centos/8/dependencies/libuv/v1.35.0/libuv-1.35.0-1.el8.x86_64.rpm',
					'libuv-devel'	=> 'https://downloads.datastax.com/cpp-driver/centos/8/dependencies/libuv/v1.35.0/libuv-devel-1.35.0-1.el8.x86_64.rpm'
				}
				
				$supportedVersions		= ['2.15.1', '2.15.2', '2.15.3', '2.16.0']
				$cassaDriverSource		= "https://downloads.datastax.com/cpp-driver/centos/8/cassandra/v${version}/cassandra-cpp-driver-${version}-1.el8.x86_64.rpm"
				$cassaDriverDevelSource	= "https://downloads.datastax.com/cpp-driver/centos/8/cassandra/v${version}/cassandra-cpp-driver-devel-${version}-1.el8.x86_64.rpm"
			} else {
		    	fail( "CentOS support only tested on major version 7 or 8, you are running version '${::operatingsystemmajrelease}'" )
		    }
		    
		    if ! ( $version in $supportedVersions ) {
		    	fail( "This Cassandra Driver Version is not suported for CentOS '${::operatingsystemmajrelease}'" )
		    }
		    
		    $dependencies.each |String $packageKey, String $packageSource| {
		    	Package { "${packageKey}":
					provider	=> 'rpm',
					ensure      => 'installed',
		            source   	=> $packageSource,
		        }
		    }
		    
			Package { 'cassandra-cpp-driver':
				provider	=> 'rpm',
				ensure      => 'installed',
	            source   	=> $cassaDriverSource,
	            require		=> [Package['libuv'], Package['libuv-devel']],
	        } ->
	        Package { 'cassandra-cpp-driver-devel':
				provider	=> 'rpm',
				ensure      => 'installed',
	            source   	=> $cassaDriverDevelSource,
	        }
	        
	        #################################################################
	        # DataStax Php Driver from Pecl require php version max 7.0.x
	        # From GitHub this driver support all php 7 versions
	        #################################################################
	        if $installDriver {
	        	if $installDriverFromGitHub {
	        		archive { '/tmp/datastaxphpdriver.zip':
						ensure        	=> present,
						source        	=> "https://github.com/datastax/php-driver/archive/refs/heads/master.zip",
						extract       	=> true,
						extract_path  	=> '/tmp',
						cleanup       	=> true,
					} ->
					Exec { 'Build and Instal Cassandra PHP Driver':
		        		command	=> 'pear install /tmp/php-driver-master/ext/package.xml',
		        		require     => [Class['php::pear'], Class['php::dev'], Package['cassandra-cpp-driver-devel']],
			        }
	        	} else {
	        		Exec { 'Update Pear Channel':
		        		command	=> 'pear channel-update pecl.php.net',
			        } ->
			        Package { 'cassandra':
			        	provider	=> 'pecl',
			        	require     => [Class['php::pear'], Class['php::dev'], Package['cassandra-cpp-driver-devel']],
					}
	        	}
	        	
	        	File { '/etc/php.d/cassandra.ini':
			        ensure  => file,
			        path    => '/etc/php.d/cassandra.ini',
			        content => template( 'vs_devenv/cassandra.ini.erb' ),
			        mode    => '0755',
			        require	=> [Class['vs_lamp']],
			        notify  => Service['httpd'],
			    }
	        }
		}
	}
}
