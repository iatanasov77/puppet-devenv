class vs_devenv::frontendtools (
    Hash $frontendtools = {},
) {

	if defined( $frontendtools['nvm'] ) {
		# Multiple NodeJs Versions
	    class { 'nvm':
			user => 'vagrant',
		} ->
		
		$frontendtools['nvm'].each |Integer $index, String $nodeVersion| {
			nvm::node::install { "${nodeVersion}":
			    user    => 'vagrant',
			    set_default => ($index == 0),
			} ->
		}
	} else {
		# Only one NodeJs Version
	    class { 'nodejs':
	        version       => "${frontendtools['nodejs']}",
	        target_dir    => '/usr/bin',
	    }
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
                    require     => Class['nodejs']
                }
            }
        }
    }
    
}
