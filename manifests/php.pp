
class devenv::php
{
    # PHP Modules
    $modules = {}
    $vsConfig['phpModules'].each |Integer $index, String $value| {
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
        
        settings   => {
            'PHP/memory_limit'        => '-1',
            'Date/date.timezone'      => 'Europe/Sofia',
        },
        extensions => $modules
    }
}
