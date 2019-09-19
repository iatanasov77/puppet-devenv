
class devenv::php
{
    class { '::php':
        ensure       => latest,
        manage_repos => true,
        fpm          => true,
        dev          => true,
        composer     => true,
        pear         => true,
        phpunit      => false,
        
        settings   => {
            'PHP/memory_limit'        => '-1',
            'Date/date.timezone'      => 'Europe/Sofia',
        },
        
    /*
        extensions => {
            bcmath    => { },
            imagick   => {
                provider => pecl,
            },
            xmlrpc    => { },
            memcached => {
                provider        => 'pecl',
                header_packages => [ 'libmemcached-devel', ],
            },
            apc       => {
                provider => 'pecl',
                settings => {
                    'apc/stat'       => '1',
                    'apc/stat_ctime' => '1',
                },
                sapi     => 'fpm',
            },
            'intl' => {
                ini_prefix => '20-',
            },
        },
    */
    
    }
    
    /*
    case $operatingsystem 
    {
        'RedHat', 'CentOS', 'Fedora': 
        {
            # remove old php packages
            $removePackages = ["mod_php", "php-common"]
            package { $removePackages:
                ensure => purge,
            }
            
            # install new packages
            $installPackages = ["mod_php72u"]
            package { $installPackages:
                ensure => present,
            }
        }
    }
    */
}
