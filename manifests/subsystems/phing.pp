########################################
# Php Build Tool PHING
########################################
class vs_devenv::subsystems::phing (
	Hash $config    = {},
) {
    notify { "INSTALLING PHING ( PHP BUILD TOOL )":
        withpath => false,
    }
    wget::fetch { 'https://www.phing.info/get/phing-latest.phar':
        destination => "/usr/share/php/",
        timeout     => 0,
        verbose     => true,
    } ->
    file { '/usr/share/php/phing-latest.phar':
        ensure  => file,
        mode    => '0777',
    } ->
    file { '/usr/local/bin/phing':
        ensure  => link,
        target  => '/usr/share/php/phing-latest.phar',
        mode    => '0777',
    }
}
