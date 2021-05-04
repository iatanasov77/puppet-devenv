class vs_devenv::subsystems::cassandra (
	Hash $config    = {},
) {
	case $::operatingsystem {
    	centos: {
			if $::operatingsystemmajrelease == '7' {
				$cassandraPackage	= 'dsc21'
			} elsif $::operatingsystemmajrelease == '8' {
				$cassandraPackage	= 'dsc30'
			} else {
		    	fail( "CentOS support only tested on major version 7 or 8, you are running version '${::operatingsystemmajrelease}'" )
		    }
		}
	}
   
	###########################################
	# Install DataStax Cassandra Dependencies
	###########################################
	class { 'vs_devenv::subsystems::cassandra::dependencies':
		
	} ->
	
	###########################################
	# Install and start DataStax Cassandra
	###########################################
	class { 'vs_devenv::subsystems::cassandra::server':
		cassandraPackage	=> $cassandraPackage,
	} ->
	
	########################################
	# Install PHP driver for Cassandra
	########################################
	class { 'vs_devenv::subsystems::cassandra::phpDriver':
		version			=> $config['phpDriverVersion'],
		installDriver	=> $config['phpDriverInstall'],
	}
	
	###############################################
	# Create database structure and add demo data
	###############################################
	if $config['database'] {
		wait_for { 'a_minute_before_cassandra_server_is_ready':
			seconds => 60,
		}
		Exec { "cqlsh -f ${config['database']}":
			command	=> "cqlsh -f ${config['database']}",
			require => Class['vs_devenv::subsystems::cassandra::server'],
		}
	}
}
