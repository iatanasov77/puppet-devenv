class vs_devenv::subsystems::payment_gateways (
    Hash $config    = {},
) {
    if ( 'stripe_cli' in $config and $config['stripe_cli'] ) {
        yumrepo { 'stripe':
            ensure      => 'present',
            name        => 'stripe',
            descr       => 'Stripe Repository',
            baseurl     => 'https://packages.stripe.dev/stripe-cli-rpm-local/',
            enabled     => true,
            gpgcheck    => 0,
        } ->
        Package { 'stripe':
            ensure  => present,
        }
    }
}
