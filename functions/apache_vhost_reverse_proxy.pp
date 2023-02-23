function vs_devenv::apache_vhost_reverse_proxy( $port )
{
    "ProxyPreserveHost On
    ProxyPass / http://127.0.0.1:${port}
    ProxyPassReverse / http://127.0.0.1:${port}"
}
