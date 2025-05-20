function vs_devenv::apache_vhost_reverse_proxy( $port, $path = '/', $scheme = 'http' )
{
    "ProxyPreserveHost On
    ProxyPass ${path} ${scheme}://127.0.0.1:${port}
    ProxyPassReverse ${path} ${scheme}://127.0.0.1:${port}"
}
