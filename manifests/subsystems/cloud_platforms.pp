class vs_devops::subsystems::cloud_platforms (
    Hash $config    = {},
) {
    class { 'vs_core::cloud_platforms':
        config  => $config,
    }
}
