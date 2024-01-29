class vs_devenv::npm_login (
    Hash $npmCredentials,
) {

    # Set Environement Variables for NPM Access
    file { "/etc/profile.d/npm_credentials.sh":
        ensure  => present,
        content => template( 'vs_devenv/npm_credentials.sh.erb' )
    }
    
}
