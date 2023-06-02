class vs_devenv::subsystems::docker (
	Hash $config    = {},
) {
	class { 'vs_core::docker':
        config  => $config,
    }
}
