function vs_devenv::apache_vhost_jsp( $port = '8080', $protocol = 'ajp' )
{
    "
    ProxyRequests off
    ProxyPass / ${protocol}://127.0.0.1:${port}/
    ProxyPassReverse / ${protocol}://127.0.0.1:${port}/
    "
}
