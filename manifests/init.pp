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
	stage { 'install-dependencies': before => Stage['rvm-install'] }
	class {
      'vs_devenv::yumrepos': stage => 'install-dependencies';
      'vs_devenv::dependencies': stage => 'install-dependencies';
    }
    
    stage { 'after-main': }
	Stage['main'] -> Stage['after-main']
	
    if ( $forcePhp7Repo ) {
        class { 'vs_devenv::force::php7_repo':
        	phpVersion	=> $phpVersion
        }
    }
    
    if ( $::operatingsystem == 'centos' and $::operatingsystemmajrelease == '7' and $mySqlProvider == 'mysql' ) {
        include vs_devenv::force::mysql_comunity_repo
    }
    
    class { '::vs_devenv::packages':
        packages        => $packages,
        gitUserName     => $gitUserName,
        gitUserEmail    => $gitUserEmail,
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
        defaultHost         => "${hostname}",
        defaultDocumentRoot => '/vagrant/gui_symfony/public',
        installedProjects   => $installedProjects,
        dotnetCore          => ( has_key( $subsystems, 'dotnet' ) and $subsystems['dotnet']['enabled'] ),
        sslModule			=> ( 'ssl' in $apacheModules ),
        python				=> ( ( 'wsgi' in $apacheModules ) and $subsystems['django']['enabled'] ),
        ruby				=> ( ( 'passenger' in $apacheModules ) and $subsystems['rubyonrails']['enabled'] ),
    }

	if ( $ansibleConfig['enabled'] ) {    
	    class { '::vs_devenv::ansible':
	        pathRoles   => $ansibleConfig['pathRoles'],
	        logPath     => $ansibleConfig['logPath'],
	        galaxyRoles => $ansibleConfig['galaxyRoles'],
	    }
	}
	
	include vs_devenv::sendmail
}
