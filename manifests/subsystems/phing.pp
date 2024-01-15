########################################
# Php Build Tool PHING
########################################
class vs_devenv::subsystems::phing (
	Hash $config    = {},
) {
    /*
     * Phing Official Site: https://www.phing.info
     */
    case $config['version']
    {
        '3.0.0-rc6':
        {
            $sourceUrl  = "https://github.com/phingofficial/phing/releases/download/${config['version']}/phing-3.0.0-RC6.phar"
        }
        default:
        {
            $sourceUrl  = "https://github.com/phingofficial/phing/releases/download/${config['version']}/phing-${config['version']}.phar"
        }
    }
    
    wget::fetch { "Install Phing Build Tool":
        source      => "${sourceUrl}",
        destination => '/usr/local/bin/phing',
        verbose     => true,
        mode        => '0777',
        cache_dir   => '/var/cache/wget',
    }
        
        
    /* OLD WAY 
    
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
    
    */
}
