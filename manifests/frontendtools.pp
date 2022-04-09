class vs_devenv::frontendtools (
    Hash $frontendtools = {},
) {
	# Install Multiple NodeJs Versions If Defined
	###################################################
	if has_key( $frontendtools, 'nvm' ) {
	    class { 'nvm':
			user 				=> $frontendtools['nvm']['user'],
			node_instances		=> $frontendtools['nvm']['node_instances'],
			manage_dependencies	=> false,
			manage_profile		=> false,
		} ->
		file_line { 'add NVM_DIR to profile file':
	    	path => "/home/${frontendtools['nvm']['user']}/.bashrc",
	      	line => "export NVM_DIR=/home/${frontendtools['nvm']['user']}/.nvm",
	    } ->
	    file_line { 'add . ~/.nvm/nvm.sh to profile file':
	      	path => "/home/${frontendtools['nvm']['user']}/.bashrc",
	      	line => "[ -s \"\$NVM_DIR/nvm.sh\" ] && . \"\$NVM_DIR/nvm.sh\"  # This loads nvm",
	    }
	}
	
	# Sysstem NodeJs is needed
    class { 'nodejs':
        version       => "${frontendtools['nodejs']}",
        target_dir    => '/usr/bin',
        build_deps    => false,
    }
    
    $frontendtools['tools'].each |String $key, Hash $data| {
     
        case $key
        {
            'angular-cli':
            {
                exec { 'Install Angular CLI':
                    command => '/usr/bin/yarn global add @angular/cli',
                    creates => '/usr/lib/node_modules/@angular/cli/bin/ng',
                    require => Package['yarn']
                }
            }
            
            default:
            {
            	package { "${key}":
                    provider    => 'npm',
                    require     => Class['nodejs'],
                }
            }
        }
    }
}
