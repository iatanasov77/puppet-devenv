
class devenv::php
{
    # PHP Modules
    $modules = {}
    each( $facts['php_modules'] ) |$value| {
        $modules.merge!({
            "${value}"  => {
                ini_prefix => '99-',
            }
        })
    }

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
        extensions => $modules
    }
}
