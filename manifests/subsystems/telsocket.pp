class vs_devenv::subsystems::telsocket (
    Hash $config    = {},
) {
    class { 'vs_core::telsocket':
        version  => $config['version'],
    }
}
