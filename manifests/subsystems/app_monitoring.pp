class vs_devenv::subsystems::app_monitoring (
    Hash $config = {},
) {
    if ( $config['grafana']['enabled'] ) {
        class { 'vs_core::app_monitoring':
            grafanaConfig => $config['grafana'],
        }
    }
}