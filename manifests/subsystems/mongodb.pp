class vs_devenv::subsystems::mongodb (
	Hash $config    = {},
) {
	case $::operatingsystem {
    	centos: {
			if $::operatingsystemmajrelease == '7' {
				
			} elsif $::operatingsystemmajrelease == '8' {
				
			} else {
		    	fail( "CentOS support only tested on major version 7 or 8, you are running version '${::operatingsystemmajrelease}'" )
		    }
		    
		    yumrepo { 'mongodb-org':
				descr      	=> 'MongoDB Repository',
		        ensure      => 'present',
		        enabled     => true,
		        gpgcheck	=> 1,
		        priority    => 50,
		        baseurl		=> 'https://repo.mongodb.org/yum/redhat/$releasever/mongodb-org/4.4/x86_64/',
		        gpgkey		=> 'https://www.mongodb.org/static/pgp/server-4.4.asc',
		        #require     => $requiredPackages,
		    } ->
		    Package { 'mongodb-org':
	            ensure   => 'present',
	        } ->
	        Service { 'mongod':
	            ensure  => 'running',
	            enable	=> true,
	        }
		}
	}
}
