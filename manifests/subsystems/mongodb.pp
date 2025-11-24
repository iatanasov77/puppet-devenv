class vs_devenv::subsystems::mongodb (
	Hash $config    = {},
) {
	case $facts['os']['name'] {
    	'RedHat', 'CentOS', 'OracleLinux', 'Fedora', 'AlmaLinux': {
		    yumrepo { 'mongodb-org':
				descr      	=> 'MongoDB Repository',
		        ensure      => 'present',
		        enabled     => true,
		        gpgcheck	=> 1,
		        priority    => 50,
		        baseurl		=> "https://repo.mongodb.org/yum/redhat/${facts['os']['release']['major']}/mongodb-org/${config['version']}/x86_64/",
		        gpgkey		=> "https://www.mongodb.org/static/pgp/server-${config['version']}.asc",
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
