class vs_devops::subsystems::hashicorp (
	Hash $config       = {},
) {
    class { 'vs_core::hashicorp':
        config  => $config,
    }
}
