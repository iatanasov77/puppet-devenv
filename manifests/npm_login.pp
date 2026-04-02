class vs_devenv::npm_login (
    Hash $npmCredentials,
) {

    #################################################
    # Set Environement Variables for NPM Access
    #################################################
    file { "/etc/profile.d/npm_credentials.sh":
        ensure  => present,
        content => template( 'vs_devenv/npm_credentials.sh.erb' ),
    }
    
    file { "/usr/local/bin/npm_login.sh":
        ensure  => present,
        content => template( 'vs_devenv/npm_login.sh.erb' ),
        mode    => "0777",
    }
    
    -> exec { 'Vagrant User NPM Login':
        command => '/usr/local/bin/npm_login.sh',
        user    => 'vagrant',
        timeout => 0,
        require => [
            Class['nodejs'],
            Class['vs_core::frontendtools']
        ],
    }
    
    #######################################
    # Add NPM Auth Script
    #######################################
    file { '/usr/local/bin/npm-auth':
        ensure  => present,
        owner   => 'root',
        group   => 'root',
        mode    => '0777',
        source  => 'puppet:///modules/vs_devenv/npm_auth.sh',
    }
    
    /*
    -> exec { 'Vagrant User NPM Auth':
        command => '/usr/local/bin/npm-auth',
        user    => 'vagrant'
    }
    */
}
