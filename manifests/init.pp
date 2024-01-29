class vs_devenv (
	Hash $dependencies					= {},
    String $hostIp                      = '0.0.0.0',
	
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
	Array $gitCredentials				= [],

    Array $apacheModules                = [],
    String $apacheVersion               = 'installed',   # Latest Version
    String $phpVersion                  = '7.2',
    
    String $mysqllRootPassword          = 'vagrant',
	$mySqlProvider						= false,
	
    Hash $phpModules                    = {},
    Hash $removePhpIniFiles             = {},
    Boolean $phpunit                    = false,
    
    Hash $phpSettings                   = {},
    
    Hash $phpMyAdmin					= {},
    Hash $databases						= {},
    
    Hash $frontendtools                 = {},
    Hash $npmCredentials,
    Hash $vstools                       = {},
    
    Boolean $forcePhp7Repo              = true,
    
    Hash $ansibleConfig                 = {},
    
    Hash $finalFixes                    = {},
) {
	# Maika mu deeba :)
	if ( $subsystems['ruby']['enabled'] ) {
		stage { 'install-dependencies': before => Stage['rvm-install'] }
	} else {
		stage { 'install-dependencies': before => Stage['main'] }
	}
	
	stage { 'after-main': }
    Stage['main'] -> Stage['after-main']
    
    class { 'vs_core::scripts':
        # This Make dependency cycle
        #stage => 'install-dependencies'
    }
    
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
    
    class { '::vs_devenv::npm_login':
        npmCredentials  => $npmCredentials,
    }
	
	include vs_core::sendmail
	
    class { '::vs_lamp':
        apacheVersion               => $apacheVersion,
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
    
    class { 'vs_lamp::fix_php_modules':
        stage               => 'after-main',
        removeIniFiles      => $removePhpIniFiles,
    }

    class { '::vs_devenv::php_documentor':
    
    }

	class { '::vs_devenv::subsystems':
        subsystems      => $subsystems,
    } ->
    class { '::vs_devenv::vhosts':
        hostIp              => "${hostIp}",
        defaultHost         => "${defaultHost}",
        defaultDocumentRoot => "${defaultDocumentRoot}",
        installedProjects   => $installedProjects,
        sslModule			=> ( 'ssl' in $apacheModules ),
        dotnetCore          => ( ( 'dotnet' in $subsystems ) and $subsystems['dotnet']['enabled'] ),
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
	file { "${defaultDocumentRoot}/../var/subsystems-${defaultHost}.json":
		ensure  => file,
		content => to_json_pretty( $subsystems ),
	}
    
    if ( $finalFixes['enabled'] ) { 
        class { '::vs_devenv::final_fixes':
            stage       => 'after-main',
            subsystems  => $subsystems,
            finalFixes  => $finalFixes,
        }
    }
    
	# Set Bash Aliases
	# 'bashrc' module is too OLD
	#################################
	if false {
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
}
