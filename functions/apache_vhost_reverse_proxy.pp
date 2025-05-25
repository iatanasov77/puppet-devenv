function vs_devenv::apache_vhost_reverse_proxy(
    $port,
    $path = '/',
    $scheme = 'http',
    $uri = '127.0.0.1',
    $preserveHost = true,
    $reverseProxy = true
) {
    if ( $preserveHost ) {
        $preserveHostOn = 'ProxyPreserveHost On'
    } else {
        $preserveHostOn = ''
    }
    
    if ( $reverseProxy ) {
        $proxyPassReverse   = "ProxyPassReverse ${path} ${scheme}://${uri}:${port}/"
    } else {
        $proxyPassReverse = ''
    }
    
    "${preserveHostOn}
    ProxyPass ${path} ${scheme}://${uri}:${port}/
    ${proxyPassReverse}"
}
