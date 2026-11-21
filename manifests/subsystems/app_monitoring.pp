class vs_devenv::subsystems::app_monitoring (
    Hash $config                = {},
    String $systemd_unit_path   = '/etc/systemd/system',
    String $hostIp              = '0.0.0.0',
) {
    if ( $config['grafana']['enabled'] ) {
        class { 'vs_core::app_monitoring::grafana':
            config => $config['grafana'],
        }
    }
}