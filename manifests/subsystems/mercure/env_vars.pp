class vs_devenv::subsystems::mercure::env_vars (
    Hash $mercure = {},
) {
    file { 'MERCURE_CONFIG_DIRECTORY':
        ensure  => directory,
        path    => '/etc/mercure',
    }
    
    file { 'MERCURE_ENV_FILE':
        ensure  => file,
        path    => '/etc/mercure/mercure.env',
        mode    => '0644',
        require => File['MERCURE_CONFIG_DIRECTORY'],
    }

    file_line { "MERCURE_SERVER_NAME_IS_REQUIRED":
        ensure  => present,
        line    => "SERVER_NAME=:${mercure['port']}",
        path    => "/etc/mercure/mercure.env",
        require => File['MERCURE_ENV_FILE'],
    }
    
    file_line { "MERCURE_HTTP_EXPOSE_IS_REQUIRED":
        ensure  => present,
        line    => "HTTP_EXPOSE=9998:${mercure['port']}",
        path    => "/etc/mercure/mercure.env",
        require => File['MERCURE_ENV_FILE'],
    }
    
    file_line { "MERCURE_HTTPS_EXPOSE_IS_REQUIRED":
        ensure  => present,
        line    => "HTTPS_EXPOSE=9999:${mercure['port']}",
        path    => "/etc/mercure/mercure.env",
        require => File['MERCURE_ENV_FILE'],
    }
    
    file_line { "MERCURE_PUBLISHER_JWT_KEY_IS_REQUIRED":
        ensure  => present,
        line    => "MERCURE_PUBLISHER_JWT_KEY=${mercure['jwtSecret']}",
        path    => "/etc/mercure/mercure.env",
        require => File['MERCURE_ENV_FILE'],
    }
    
    file_line { "MERCURE_SUBSCRIBER_JWT_KEY_IS_REQUIRED":
        ensure  => present,
        line    => "MERCURE_SUBSCRIBER_JWT_KEY=${mercure['jwtSecret']}",
        path    => "/etc/mercure/mercure.env",
        require => File['MERCURE_ENV_FILE'],
    }
    
    file_line { "MERCURE_EXTRA_DIRECTIVES_IS_REQUIRED":
        ensure  => present,
        line    => "MERCURE_EXTRA_DIRECTIVES=anonymous cors_origins *",
        path    => "/etc/mercure/mercure.env",
        require => File['MERCURE_ENV_FILE'],
    }
}