class vs_devenv::subsystems::cassandra::server (
	String $cassandraPackage,
) {
	case $::operatingsystem {
    	#centos: {
    	'RedHat', 'CentOS', 'OracleLinux', 'Fedora', 'AlmaLinux': {
			yumrepo { 'datastax':
				descr      	=> 'DataStax Repo for Apache Cassandra',
		        ensure      => 'present',
		        enabled     => true,
		        gpgcheck	=> 0,
		        priority    => 50,
		        baseurl		=> 'http://rpm.datastax.com/community',
		        #require     => $requiredPackages,
		    } ->
		    Package { "${cassandraPackage}":
	            ensure   => 'present',
	        } ->
	        Service { 'cassandra':
	            ensure  => 'running',
	            enable	=> true,
	        }
	    }
	}
}
