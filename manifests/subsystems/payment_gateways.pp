class vs_devenv::subsystems::payment_gateways (
    Hash $config    = {},
) {
    if ( 'stripe_cli' in $config and $config['stripe_cli'] ) {
        yumrepo { 'stripe':
            ensure      => 'present',
            name        => 'stripe',
            baseurl     => 'https://packages.stripe.dev/stripe-cli-rpm-local/',
            enabled     => true,
            gpgcheck    => false,
        } ->
        Package { 'stripe':
            ensure  => present,
        }
    }
}
