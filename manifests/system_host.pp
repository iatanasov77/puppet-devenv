define vs_devenv::system_host (
    String $hostIp,
    String $hostName,
) {
    host { "${hostName}":
        ip  => "${hostIp}",
    }
}