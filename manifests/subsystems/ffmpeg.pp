class vs_devenv::subsystems::ffmpeg (
    Hash $config    = {},
) {
    class { 'vs_core::ffmpeg':
        config  => $config,
    }
}