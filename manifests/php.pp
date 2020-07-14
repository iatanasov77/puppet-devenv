
class devenv::php
{
    $repo   = sprintf( 'remi-php%s', regsubst( String( $vsConfig['phpVersion'] ), '.', '', 'G' ) )
    
    #Yumrepo { "${repo}":
    #    descr      => 'Remi\'s PHP 7 RPM repository for CentOS 7',
    #    #mirrorlist => 'http://cdn.remirepo.net/enterprise/7/php72/mirror',
    #    enabled    => 1,
    #    gpgcheck   => 1,
    #    gpgkey     => 'http://rpms.remirepo.net/RPM-GPG-KEY-remi'
    #}
  
    # PHP Modules
    $modules = {}
    $vsConfig['phpModules'].each |Integer $index, String $value| {
    
        notify { "INSTALLING PHP MUDULE: ${value}":
    		withpath => false,
		}
		
        if ( $value == 'apc' or $value == 'xdebug' or $value == 'mongodb' ) {
            next()
        }
        
    	$modules = merge( $modules, {
            "${value}"  => {}
        })
    }

#    class { '::php::globals':
#        php_version => '7.2',
#        #config_root => '/etc/php/7.0',
#    }->
    class { '::php':
        ensure       => latest,
        manage_repos => true,
        fpm          => true,
        dev          => true,
        composer     => true,
        pear         => true,
        phpunit      => true,
        
        #package_prefix => 'php72-php-',
        
        settings   => {
            'PHP/memory_limit'        => '-1',
            'Date/date.timezone'      => 'Europe/Sofia',
            'PHP/post_max_size'       => '64M',
            'PHP/upload_max_filesize' => '64M',
        },
        extensions => $modules
    }
    
    ########################################
    # Php Build Tool PHING
    ########################################
    notify { "INSTALLING PHING ( PHP BUILD TOOL )":
        withpath => false,
    }
    wget::fetch { 'https://www.phing.info/get/phing-latest.phar':
        destination => "/usr/share/php/",
        timeout     => 0,
        verbose     => true,
    } ->
    file { '/usr/local/bin/phing':
        ensure  => link,
        target  => '/usr/share/php/phing-latest.phar',
        mode    => '0777',
    }
}
