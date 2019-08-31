class devenv::lamp
{
	# Install and setup an Apache server with mod_php
	class { 'apache':
		default_vhost 	=> false,
		default_mods	=> false,
		mpm_module 		=> 'prefork',
	}

	# Apache modules
	class { 'apache::mod::expires': }
	class { 'apache::mod::headers': }
	class { 'apache::mod::rewrite': }
	class { 'apache::mod::vhost_alias': }
	class { 'devenv::php': }
	
	class { 'apache::mod::php': 
		php_version	=> $phpVersion,
	}

	# Install and setup MySql server
	exec { 'mkdir -p /var/log/mariadb':
		path     => '/usr/bin:/usr/sbin:/bin',
		provider => shell
	}
	class { 'mysql::server':
		create_root_user	=> true,
		root_password		=> 'vagrant',
	}
	
	mysql::db { 'devenv_task':
		user		=> 'root',
		password	=> 'vagrant',
		host		=> "${mysqlhost}",
		grant		=> ['ALL'],
		sql			=> "${mysqldump}"
	}
      
	# Install PhpMyAdmin
	class { 'phpmyadmin': }
	phpmyadmin::server{ 'default': }

	# Setup default main virtual host
	apache::vhost { "${hostname}":
		port    	=> '80',
		docroot 	=> "${documentroot}", 
		override	=> 'all',
		php_values 		=> ['memory_limit 1024M'],
		
		directories => [
			{
				'path'		=> "${documentroot}",
				'override'	=> 'All',
				'Require'	=> 'all granted' ,
			},
			{
				'path'		=> '/usr/share/phpmyadmin',
				'Require'	=> 'all granted' ,
			}
		],
		
		aliases		=> [
			{
				alias => '/phpMyAdmin',
				path  => '/usr/share/phpmyadmin'
			}, 
			{
				alias => '/phpmyadmin',
				path  => '/usr/share/phpmyadmin'
			}
		],
	}
}
