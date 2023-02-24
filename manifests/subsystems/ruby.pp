class vs_devenv::subsystems::ruby (
	Hash $config    = {},
) {
    if ! defined(Class['vs_devenv::subsystems::ruby::rvm']) {
    	class { 'vs_devenv::subsystems::ruby::rvm':
            rubyDefaultVersion => "${config['rubyDefaultVersion']}",
        }
    }
    
    $config['virtual_environments'].each |String $venvId, Hash $venvConfig| {
    	rvm_system_ruby {
			"ruby-${venvConfig['rubyVersion']}":
			    ensure      => 'present',
			    default_use => $venvConfig['defaultUse'];
		}
		
		$venvConfig['packages'].each |String $package| {
    		rvm_gem {
				"${package}":
					name         => "${package}",
					ruby_version => "ruby-${venvConfig['rubyVersion']}",
					ensure       => latest,
					require      => Rvm_system_ruby["ruby-${venvConfig['rubyVersion']}"];
			}
    	}
    }
}
