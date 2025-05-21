function vs_devenv::apache_vhost_reverse_proxy( $port, $path = '/', $scheme = 'http', $preserveHost = true )
{
    if ( $preserveHost ) {
        "ProxyPreserveHost On
        ProxyPass ${path} ${scheme}://127.0.0.1:${port}
        ProxyPassReverse ${path} ${scheme}://127.0.0.1:${port}"
    } else {
        "ProxyPass ${path} ${scheme}://127.0.0.1:${port}/
        ProxyPassReverse ${path} ${scheme}://127.0.0.1:${port}/"
    }
}
