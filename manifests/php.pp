
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
        extensions => {
        	'pdo' => {
	          ini_prefix => '20-',
	          multifile_settings => true,
	          settings => {
	              'pdo'  => {},
	              'pdo_sqlite' => {},
	              'sqlite3' => {},
	            },
	        },
	        'mysqlnd' => {
	          ini_prefix => '30-',
	          multifile_settings => true,
	          settings => {
	             'mysqlnd'  => {},
	             'mysql' => {},
	             'mysqli' => {},
	             'pdo_mysql' => {},
	             'sysvshm' => {},
	          },
	        },
        }
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
