class vs_devenv::subsystems::python (
	Hash $config    = {},
) {
	class { '::vs_django':
		#stage	 => 'after-main',
        #require => Class['vs_lamp::apache'],
        #notify  => Class['apache::service'],
    }
    
    $config['virtual_environments'].each |String $key, Hash $options| {
    	vs_django::virtualenv{ "${key}":
    		venv			=> $key,
        	pythonVersion	=> $options['pythonVersion'],
	        packages        => $options['packages'],
	    }
    }
}
