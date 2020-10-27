function vs_devenv::apache_vhost_jsp( $port )
{
    "
    ProxyRequests off
    ProxyPass / ajp://127.0.0.1:${port}/
    ProxyPassReverse / ajp://127.0.0.1:${port}/
    "
}
