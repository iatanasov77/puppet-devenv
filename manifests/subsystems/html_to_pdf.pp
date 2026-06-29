class vs_devenv::subsystems::html_to_pdf (
    Hash $config    = {},
) {
    case $facts['os']['name'] {
        'RedHat', 'CentOS', 'OracleLinux', 'Fedora', 'AlmaLinux': {
            $packageProvider    = 'rpm'
            $wkhtmltopdfSource  = "https://github.com/wkhtmltopdf/packaging/releases/download/${config['version']}/wkhtmltox-${config['version']}.almalinux8.x86_64.rpm"
            
            $dependencies = ['freetype', 'xorg-x11-fonts-75dpi']
        }
        
        'Debian', 'Ubuntu': {
            $packageProvider    = 'deb'
            $wkhtmltopdfSource  = "https://github.com/wkhtmltopdf/packaging/releases/download/${config['version']}/wkhtmltox_${config['version']}.buster_amd64.deb"
            
            $dependencies = []
        }
        
        default: { fail( "Unsupported OS '${::operatingsystem}'" ) }
    }
    
    $dependencies.each |String $value|
    {
        if ! defined( Package[$value] ) {
            package { $value:
                ensure => present,
            }
        }
    }
    
    package { 'wkhtmltox':
        provider  => $packageProvider,
        ensure    => installed,
        source    => $wkhtmltopdfSource,
    }
}