/**
 * Docker Web Gui
 *----------------
 * Used Example: https://github.com/itsbcit/puppet-portainer
 */
class vs_devenv::subsystems::docker::portainer(
    String $systemd_unit_path   = '/etc/systemd/system',
    String $data_path           = '/opt/portainer',
    String $admin_password      = 'Portainer@123',
) {
    
    $portainerPasswordFile  = '/tmp/portainer_password'
    file { "${portainerPasswordFile}":
        content => $admin_password,
    } ->
    
    /**
     * https://blog.marcnuri.com/docker-container-as-linux-system-service
     */
    file { 'portainer.service':
        path    => "${systemd_unit_path}/portainer.service",
        owner   => root,
        group   => root,
        mode    => '0444',
        content => template( 'vs_devenv/portainer.service.erb' ),
        notify  => [
            Exec['daemon-reload'],
            Service['portainer'],
        ],
    }
    
    file { 'portainer_data_path':
        ensure => directory,
        path   => "${data_path}",
        owner  => root,
        group  => root,
        mode   => '0750',
    }
    
    exec { 'daemon-reload':
        command     => 'systemctl daemon-reload',
        path        => '/bin:/sbin:/usr/bin:/usr/sbin',
        refreshonly => true,
    }
    
    service { 'portainer':
        ensure      => running,
        enable      => true,
        provider    => systemd,
        timeout     => 3600,
        require     => File['portainer.service'],
    }
}