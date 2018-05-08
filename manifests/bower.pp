class devenv::bower
{
	class { '::nodejs':
		version 	=> 'v6.13.1',
		node_path	=> '/usr/share/nodejs',
	}

	package { 'bower':
		provider 	=> 'npm',
		require  	=> Class['nodejs']
	}
}
