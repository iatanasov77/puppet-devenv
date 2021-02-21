#########################################################################
#
#
#########################################################################
function vs_devenv::apache_vhost_jsp_rewrite( $host = 'example.com', $tomcatUrl = 'http://127.0.0.1:8080' )
{
    "
    ProxyRequests off
    ProxyPreserveHost on
    
    RewriteEngine     on
    RewriteCond %{HTTP_HOST} ^${host}(:80)?\$
    RewriteRule /(.*) ${tomcatUrl}/\$1 [P]
    "
}
