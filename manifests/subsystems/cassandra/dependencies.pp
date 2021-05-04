class vs_devenv::subsystems::cassandra::dependencies (
	
) {
	case $::operatingsystem {
    	centos: {
    		if ! defined(Class['java']) {
	    		class { 'java' :
			        package => 'java-1.8.0-openjdk-devel',
			    }
		    }
		    
    		if ! defined(Package['python2']) {
			    Package { 'python2':
		            ensure   => 'present',
		        }
		    }
		    
		    file { '/usr/bin/python':
		        ensure  => link,
		        target  => '/usr/bin/python2',
		        mode    => '0777',
		    }
	    }
	}
}
