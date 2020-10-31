class vs_devenv (
    String $defaultHost,
    String $defaultDocumentRoot,
    Hash $installedProjects             = {},
    
    Hash $subsystems                    = {},
    
    Array $packages                     = [],
    String $gitUserName                 = 'undefined_user_name',
    String $gitUserEmail                = 'undefined@example.com',


    Array $apacheModules                = [],
    String $phpVersion                  = '7.2',
    
    String $mysqllRootPassword          = 'vagrant',
	$mysqlPackageName					= false,
	
    Hash $phpModules                    = {},
    Boolean $phpunit                    = false,
    
    Hash $phpSettings                   = {},
    
    Hash $phpMyAdmin					= {},
    Hash $databases						= {},
    
    Hash $frontendtools                 = {},
    Hash $vstools                       = {},
    
    Boolean $forcePhp7Repo              = true,
    Boolean $forceMySqlComunityRepo     = true,
) {
	include vs_devenv::dependencies
	
    if ( $forcePhp7Repo ) {
        include vs_devenv::force::php7_repo
    }
    
    if ( $forceMySqlComunityRepo ) {
        include vs_devenv::force::mysql_comunity_repo
    }
    
    class { '::vs_devenv::packages':
        packages        => $packages,
        gitUserName     => $gitUserName,
        gitUserEmail    => $gitUserEmail,
    }

    class { '::vs_lamp':
        phpVersion                  => $phpVersion,
        apacheModules               => $vsConfig['apacheModules'],
        
        mysqllRootPassword          => $mysqllRootPassword,
        mysqlPackageName            => $mysqlPackageName,

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
    
    class { '::vs_devenv::subsystems':
        subsystems      => $subsystems,
    }
    
    class { '::vs_devenv::vstools':
        vstools => $vstools,
    }

    class { '::vs_devenv::frontendtools':
        frontendtools   => $frontendtools,
    }
    
    class { '::vs_devenv::vhosts':
        defaultHost         => "${hostname}",
        defaultDocumentRoot => '/vagrant/gui_symfony/public',
        installedProjects   => $installedProjects,
        dotnetCore          => has_key( $subsystems, 'dotnet' )	and	$subsystems['dotnet']['enabled']
    }
}
