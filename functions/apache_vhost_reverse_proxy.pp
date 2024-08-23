function vs_devenv::apache_vhost_reverse_proxy( $port, $path = '/' )
{
    "ProxyPreserveHost On
    ProxyPass ${path} http://127.0.0.1:${port}
    ProxyPassReverse ${path} http://127.0.0.1:${port}"
}
