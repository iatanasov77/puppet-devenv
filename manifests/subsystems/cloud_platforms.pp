class vs_devenv::subsystems::cloud_platforms (
    Hash $config    = {},
) {
    class { 'vs_core::cloud_platforms':
        config  => $config,
    }
}
