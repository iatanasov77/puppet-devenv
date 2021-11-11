class vs_devenv (
	Hash $dependencies					= {},
	
    String $defaultHost,
    String $defaultDocumentRoot			= '/vagrant/gui_symfony/public',
    Hash $installedProjects             = {},
    
    Hash $subsystems                    = {},
    
    Array $packages                     = [],
    String $gitUserName                 = 'undefined_user_name',
    String $gitUserEmail                = 'undefined@example.com',
	String $gitCredentials				= '',

    Array $apacheModules                = [],
    String $phpVersion                  = '7.2',
    
    String $mysqllRootPassword          = 'vagrant',
	$mySqlProvider						= false,
	
    Hash $phpModules                    = {},
    Boolean $phpunit                    = false,
    
    Hash $phpSettings                   = {},
    
    Hash $phpMyAdmin					= {},
    Hash $databases						= {},
    
    Hash $frontendtools                 = {},
    Hash $vstools                       = {},
    
    Boolean $forcePhp7Repo              = true,
    
    Hash $ansibleConfig                 = {},
) {
	# Maika mu deeba :)
	if ( $subsystems['ruby']['enabled'] ) {
		stage { 'install-dependencies': before => Stage['rvm-install'] }
	} else {
		stage { 'install-dependencies': before => Stage['main'] }
	}
	
	stage { 'after-main': }
    Stage['main'] -> Stage['after-main']
    
	class { '::vs_devenv::dependencies::repos':
		dependencies	=> $dependencies,
        forcePhp7Repo   => $forcePhp7Repo,
        phpVersion      => $phpVersion,
        mySqlProvider   => $mySqlProvider,
        stage           => 'install-dependencies',
    } ->
	class { 'vs_devenv::dependencies::packages':
        stage           => 'install-dependencies',
        gitUserName     => $gitUserName,
        gitUserEmail    => $gitUserEmail,
    }
    
    class { 'vs_devenv::dependencies::git_setup':
        stage           => 'after-main',
        gitCredentials  => $gitCredentials,
    }
    
    class { '::vs_devenv::packages':
        packages        => $packages,
    } ->
	
    class { '::vs_lamp':
        phpVersion                  => $phpVersion,
        apacheModules               => $apacheModules,
        
        mysqllRootPassword          => $mysqllRootPassword,
        mySqlProvider				=> $mySqlProvider,

        phpModules                  => $phpModules,
        phpSettings                 => $phpSettings,
        phpunit                     => $phpunit,
        phpManageRepos              => !$forcePhp7Repo,
        
        phpMyAdmin					=> $phpMyAdmin,
        databases					=> $databases,
    } 
    
    if ( $forcePhp7Repo ) {
        file { "/usr/lib64/httpd/modules/libphp${phpVersion}.so":
            ensure  => link,
            target  => '/usr/lib64/httpd/modules/libphp7.so',
        }
    }
    
    class { '::vs_devenv::vstools':
        vstools => $vstools,
    }

    class { '::vs_devenv::frontendtools':
        frontendtools   => $frontendtools,
    }

	class { '::vs_devenv::subsystems':
        subsystems      => $subsystems,
    } ->
    class { '::vs_devenv::vhosts':
        defaultHost         => "${defaultHost}",
        defaultDocumentRoot => "${defaultDocumentRoot}",
        installedProjects   => $installedProjects,
        sslModule			=> ( 'ssl' in $apacheModules ),
        dotnetCore          => ( has_key( $subsystems, 'dotnet' ) and $subsystems['dotnet']['enabled'] ),
        tomcat				=> ( $subsystems['tomcat']['enabled'] ),
        python				=> ( ( 'wsgi' in $apacheModules ) and $subsystems['python']['enabled'] ),
        ruby				=> ( ( 'passenger' in $apacheModules ) and $subsystems['ruby']['enabled'] ),
    }

	if ( $ansibleConfig['enabled'] ) {    
	    class { '::vs_devenv::ansible':
	        pathRoles   => $ansibleConfig['pathRoles'],
	        logPath     => $ansibleConfig['logPath'],
	        galaxyRoles => $ansibleConfig['galaxyRoles'],
	    }
	}
	
	include vs_devenv::sendmail
	
	file { "${defaultDocumentRoot}/../var":
		ensure  => directory,
	} ->
	file { "${defaultDocumentRoot}/../var/subsystems.json":
		ensure  => file,
		content => to_json_pretty( $subsystems ),
	}
	
	# Set Bash Aliases
	###########################
	class { '::bashrc':
		aliases    => [
			"composer='XDEBUG_MODE=off \\composer'"
		],
		users      => [
			{
				'username'			=> 'root',
				'homedirectory'		=> '/root',
				'managelocalbashrc'	=> true,
			},
			{
				'username'			=> 'vagrant',
				'homedirectory'		=> '/home/vagrant',
				'managelocalbashrc'	=> true,
			}
		]
	}
}
