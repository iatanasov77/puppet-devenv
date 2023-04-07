class vs_devenv (
	Hash $dependencies					= {},
	
    String $defaultHost,
    String $defaultDocumentRoot			= '/vagrant/gui_symfony/public',
    String $guiUrl                      = '',
    String $guiRoot                     = '',
    Hash $guiDatabase                   = {},
    
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
    
	class { '::vs_core::dependencies::repos':
		dependencies	=> $dependencies,
        forcePhp7Repo   => $forcePhp7Repo,
        phpVersion      => $phpVersion,
        mySqlProvider   => $mySqlProvider,
        stage           => 'install-dependencies',
    } ->
	class { 'vs_core::dependencies::packages':
        stage           => 'install-dependencies',
        gitUserName     => $gitUserName,
        gitUserEmail    => $gitUserEmail,
    }
    
    class { 'vs_core::dependencies::git_setup':
        stage           => 'after-main',
        gitUserName     => $gitUserName,
        gitUserEmail    => $gitUserEmail,
        gitCredentials  => $gitCredentials,
    }
    
    class { '::vs_core::packages':
        packages        => $packages,
        gitUserName     => $gitUserName,
        gitUserEmail    => $gitUserEmail,
    }
    
    class { '::vs_core::vstools':
        vstools => $vstools,
    }

    class { '::vs_core::frontendtools':
        frontendtools   => $frontendtools,
    }
	
	include vs_core::sendmail
	
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
        require     		=> Class['vs_lamp::install_mod_php'],
    }

	if ( $ansibleConfig['enabled'] ) {    
	    class { '::vs_devenv::ansible':
	        pathRoles   => $ansibleConfig['pathRoles'],
	        logPath     => $ansibleConfig['logPath'],
	        galaxyRoles => $ansibleConfig['galaxyRoles'],
	    }
	}
	
	class { '::vs_devenv::install_gui':
        guiUrl      => "${guiUrl}",
        guiRoot     => "${guiRoot}",
        database    => $guiDatabase,
        require     => Class['vs_lamp::mysql'],
	} ->
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
