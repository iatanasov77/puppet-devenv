
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
            'intl' => {
                ini_prefix => '20-',
            },
            'gd' => {
                ini_prefix => '20-',
            },
            'mbstring' => {
                ini_prefix => '20-',
            },
            'xmlrpc' => {
                ini_prefix => '20-',
            },
        	'pdo' => {
	           ini_prefix => '20-',
	           multifile_settings => true,
	           settings => {
	               'pdo'  => {},
	               'pdo_sqlite' => {},
	               'sqlite3' => {},
	            },
	        },
	        'mysql' => {
	           ini_prefix => '20-',
	           multifile_settings => true,
	           settings => {
	               'mysqlnd'  => {},
	               'mysql' => {},
	               'mysqli' => {},
	               'pdo_mysql' => {},
	               'sysvshm' => {},
	          },
	        }
           
	        /*
	        curl    => { },
	        imagick   => { provider => pecl },
	        mcrypt    => { provider => pecl },
	        json    => { provider => pecl },
	        */
        }
    }
}
