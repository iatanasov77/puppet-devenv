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

    Array $phpModules                   = [],
    Boolean $phpunit                    = false,
    
    Hash $phpSettings                   = {},
    
    String $xdebugTraceOutputName       = 'trace.out',
    String $xdebugTraceOutputDir        = '/home/nickname/Xdebug',
    String $xdebugProfilerEnable        = '0',
    String $xdebugProfilerOutputName    = 'cachegrind.out',
    String $xdebugProfilerOutputDir     = '/home/nickname/Xdebug',
    
    Hash $frontendtools                 = {},
    Hash $vstools                       = {},
    
    Boolean $forcePhp7Repo              = true,
    Boolean $forceMySqlComunityRepo     = true,
) {
    if ( $forcePhp7Repo ) {
        include vs_devenv::force::php7_repo
    }
    
    if ( $forceMySqlComunityRepo ) {
        include vs_devenv::force::mysql_comunity_repo
        
        $mysqlPackageName       = 'mysql-community-server'
        $mysqlService           = 'mysqld'
        
    } else {
        $mysqlPackageName       = ''
        $mysqlService           = ''
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
        mysqlService                => $mysqlService,

        phpModules                  => $phpModules,
        phpSettings                 => $phpSettings,
        phpunit                     => $phpunit,
        phpManageRepos              => !$forcePhp7Repo,
        
        xdebugTraceOutputName       => $xdebugTraceOutputName,
        xdebugTraceOutputDir        => $xdebugTraceOutputDir,
        xdebugProfilerEnable        => $xdebugProfilerEnable,
        xdebugProfilerOutputName    => $xdebugProfilerOutputName,
        xdebugProfilerOutputDir     => $xdebugProfilerOutputDir,
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
