# @summary
#   Return rewrite rules used in apache virtual hosts.
#
#########################################################################
function vs_devenv::apache_custom_fragment(
    Enum['fpmSocket', 'reverseProxy', 'Null']  $customFragmentType  = 'Null',
    Hash $config                                                    = {},
) {

    if ( $customFragmentType == 'fpmSocket' ) {
        <Proxy \"unix:${config['fpmSocket']}|fcgi://php-fpm\">
            ProxySet disablereuse=off
        </Proxy>
        
        <FilesMatch \.php$>
            SetHandler proxy:fcgi://php-fpm
        </FilesMatch>
    } elseif ( $customFragmentType == 'reverseProxy' ) {
        ProxyPreserveHost On
        ProxyPass / ${config['reverseProxy']}
        ProxyPassReverse / ${config['reverseProxy']}
    } else {
        Null
    }
    
}
