class vs_devenv::subsystems::cassandra (
	Hash $config    = {},
) {
	###########################################
	# Install DataStax Cassandra Dependencies
	###########################################
	class { 'vs_devenv::subsystems::cassandra::dependencies':
		
	} ->
	
	###########################################
	# Install and start DataStax Cassandra
	###########################################
	class { 'vs_devenv::subsystems::cassandra::server':
		cassandraPackage	=> $config['cassandraPackage'],
	} ->
	
	########################################
	# Install PHP driver for Cassandra
	########################################
	class { 'vs_devenv::subsystems::cassandra::phpDriver':
		version					=> $config['phpDriverVersion'],
		installDriver			=> $config['phpDriverInstall'],
		installDriverFromGitHub	=> $config['phpDriverInstallFromGitHub'],
	}
	
	###############################################
	# Create database structure and add demo data
	###############################################
	if $config['databases'] {
		wait_for { 'a_minute_before_cassandra_server_is_ready':
			seconds => 60,
		}
		$config['databases'].each |String $dbKey, String $dbDump| {
			Exec { "cqlsh -f ${config['database']}":
				command	=> "cqlsh -f ${dbDump}",
				require => Class['vs_devenv::subsystems::cassandra::server'],
				tries	=> 10,
				#try_sleep => 30, # in seconds
			}
		}
	}
}
