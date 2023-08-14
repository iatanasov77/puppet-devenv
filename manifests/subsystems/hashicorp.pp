class vs_devenv::subsystems::hashicorp (
	Hash $config       = {},
) {
    class { 'vs_core::hashicorp':
        config  => $config,
    }
}
