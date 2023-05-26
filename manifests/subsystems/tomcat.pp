class vs_devenv::subsystems::tomcat (
	Hash $config    = {},
) {
	class { 'vs_java':
        tomcatConfig    => $config,
    }
}