class devenv::mysql
{
	# Install and setup MySql server
	exec { 'mkdir -p /var/log/mariadb':
		path     => '/usr/bin:/usr/sbin:/bin',
		provider => shell
	}
	
	class { 'mysql::server':
	   service_name        => 'mysqld',
	   create_root_user    => true,
	   root_password       => 'vagrant',
	}
	
	/*
	mysql::db { 'devenv_task':
		user		=> 'root',
		password	=> 'vagrant',
		host		=> "${mysqlhost}",
		grant		=> ['ALL'],
		sql			=> "${mysqldump}"
	}
    */
}
