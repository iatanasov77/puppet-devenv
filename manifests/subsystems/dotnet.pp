class vs_devenv::subsystems::dotnet (
	Hash $config    = {},
) {
	class { '::vs_dotnet':
        sdkVersion  => $config['dotnet_core'],
        sdkUser     => $config['sdkUser'],
        sdks        => $config['sdks'],
        mono        => ( $config['mono'] == Undef ),
    }
}
