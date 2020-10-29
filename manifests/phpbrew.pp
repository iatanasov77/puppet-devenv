class vs_devenv::phpbrew (
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
       system_wide 				=> $config['system_wide'],
       additional_dependencies	=> $deps
    }
    
    exec { "Fetch Known Versions Json ...":
        command     => '/usr/bin/phpbrew known --more',
        environment => [ "PHPBREW_ROOT=/opt/phpbrew" ],
        require     => Class['phpbrew'],
    }
    
    $config['install'].each |Integer $index, String $value| {
        phpbrew::install { $value: 
           
        }
    }
}
