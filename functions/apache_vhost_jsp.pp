#########################################################################
#
#
#########################################################################
function vs_devenv::apache_vhost_jsp( $protocol = 'ajp', $port = '8080' )
{
    "
    ProxyRequests off
    ProxyPreserveHost on
    ProxyPass / ${protocol}://127.0.0.1:${port}/
    ProxyPassReverse / ${protocol}://127.0.0.1:${port}/
    "
}
