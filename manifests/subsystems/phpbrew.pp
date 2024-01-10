class vs_devenv::subsystems::phpbrew (
    Hash $config    = {},
) {
	if ( 
		'libzip-devel' in $config['additional_dependencies'] and
		$::operatingsystem == 'CentOS' and 
		$::operatingsystemmajrelease == '7' 
	) {
    	$deps	= delete($config['additional_dependencies'], 'libzip-devel')
    	
    	###########################################
		# PhpBrew build php require libzip >= 0.11
		###########################################
		exec { 'remove older libzip':
			command     => 'yum remove -y libzip'
		}
		
		package { 'libzip':
		    provider  => 'rpm',
		    ensure    => installed,
		    source    => "http://packages.psychotic.ninja/7/plus/x86_64/RPMS//libzip-0.11.2-6.el7.psychotic.x86_64.rpm",
		    require   => Exec['remove older libzip'],
		}
	
		package { 'libzip-devel':
		    provider  => 'rpm',
		    ensure    => installed,
		    source    => "http://packages.psychotic.ninja/7/plus/x86_64/RPMS//libzip-devel-0.11.2-6.el7.psychotic.x86_64.rpm",
		    require   => Exec['remove older libzip'],
		}
	} else {
		$deps	= $config['additional_dependencies']
	}
	
	file_line { "PHPBREW_ROOT_IS_REQUIRED":
        ensure  => present,
        line    => "PHPBREW_ROOT=/opt/phpbrew",
        path    => "/etc/environment",
    }
    
    class { 'phpbrew':
        version                 => $config['version'],
        system_wide 				=> $config['system_wide'],
        additional_dependencies	=> $deps
    }
    
    if $::operatingsystem == 'centos' and Integer( $::operatingsystemmajrelease ) >= 8 and ! defined(Package['php-json'])  {
    	if ! defined(Package['php-json']) {
	    	Package { 'php-json':
			    ensure    => installed,
			}
		}
		
		$fechVersionsRequire	= [Class['phpbrew'], Package['php-json']]
    } else {
    	$fechVersionsRequire	= [Class['phpbrew']]
    }
    
    exec { "Fetch Known Versions Json ...":
        command     => '/usr/bin/phpbrew known --more',
        environment => [ "PHPBREW_ROOT=/opt/phpbrew" ],
        require     => $fechVersionsRequire,
    }
    
    $config['install'].each |Integer $index, String $value| {
        phpbrew::install { $value: 
           
        }
    }
}
