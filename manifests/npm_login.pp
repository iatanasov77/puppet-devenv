class vs_devenv::npm_login (
    Hash $npmCredentials,
) {

    #################################################
    # Set Environement Variables for NPM Access
    #################################################
    file { "/etc/profile.d/npm_credentials.sh":
        ensure  => present,
        content => template( 'vs_devenv/npm_credentials.sh.erb' )
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
    
}
