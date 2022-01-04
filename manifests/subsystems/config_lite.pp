class vs_devenv::subsystems::config_lite (
    Hash $config    = {},
) {
    Exec { 'Instal Config_Lite PHP Library':
        command => "pear install Config_Lite-${config['version']}",
        require => [Class['php::pear'], Class['php::dev']],
    }
}
