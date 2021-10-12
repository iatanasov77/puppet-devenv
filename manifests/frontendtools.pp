class vs_devenv::frontendtools (
    Hash $frontendtools = {},
) {

	if has_key( $frontendtools, 'nvm' ) {
		# Multiple NodeJs Versions
	    class { 'nvm':
			user 				=> 'vagrant',
			manage_dependencies	=> false,
			manage_profile		=> false,
		} ->
		file_line { 'add NVM_DIR to profile file':
	    	path => "/home/vagrant/.bashrc",
	      	line => "export NVM_DIR=/home/vagrant/.nvm",
	    } ->
	    file_line { 'add . ~/.nvm/nvm.sh to profile file':
	      	path => "/home/vagrant/.bashrc",
	      	line => "[ -s \"\$NVM_DIR/nvm.sh\" ] && . \"\$NVM_DIR/nvm.sh\"  # This loads nvm",
	    } ->
		
		/* This Fails. I dont know why
		 ================================
		$frontendtools['nvm'].each |Integer $index, String $nodeVersion| {
			# Debuging
			#fail( "NODE INDEX: ${index}		NODE VERSION: ${nodeVersion}" )
		
			
			nvm::node::install { "${nodeVersion}":
			    user    	=> 'vagrant',
			    set_default => ($index == 0),
			}
		}
		*/
		
		nvm::node::install { '16.10.0':
		    user    	=> 'vagrant',
		    set_default => true,
		} ->
		nvm::node::install { '10.24.1':
		    user    	=> 'vagrant',
		    set_default => false,
		}
		
		$requiredPackages	= [ Class['nvm'] ]
	} else {
		# Only one NodeJs Version
	    class { 'nodejs':
	        version       => "${frontendtools['nodejs']}",
	        target_dir    => '/usr/bin',
	    }
	    
	    $requiredPackages	= [ Class['nodejs'] ]
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
                    require     => $requiredPackages,
                }
            }
        }
    }
    
}
