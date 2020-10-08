function vs_devenv::apache_vhosts( Hash $vhosts ) {
    
    
    $vhosts.each |String $host, Hash $config| {
    
        apache::vhost { "${host}":
            port        => '80',
            
            serveraliases => [
                "www.${host}",
            ],
            serveradmin => "webmaster@${host}",
    
            docroot     => $config['documentRoot'], 
            override    => 'all',
            
            directories => [
                {
                    'Require'       => 'all granted',
                    
                    path            => $config['documentRoot'],
                    allow_override  => ['All'],
                    
                    rewrites        => vs_devenv::apache_rewrite_rules( Boolean( $needRewriteRules ) )
                }
            ],
            
            custom_fragment    => $customFragment,
            log_level          => 'debug',
        }
    }
    
}