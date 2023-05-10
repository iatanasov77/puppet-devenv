class vs_devenv::final_settings
{
    class { 'vs_core::scripts': } ->
    Exec{ 'Set Java 11 As Default':
        command => '/opt/vs_devenv/set_default_java.sh',
    }
}
