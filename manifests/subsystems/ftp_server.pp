class vs_devenv::subsystems::ftp_server (
    Hash $config    = {},
) {
    class { 'vsftpd':
        anonymous_enable        => false,
        anon_mkdir_write_enable => false,
        anon_other_write_enable => false,
        local_enable            => true,
        download_enable         => true,
        write_enable            => true,
        local_umask             => '022',
        dirmessage_enable       => true,
        xferlog_enable          => true,
        connect_from_port_20    => true,
        xferlog_std_format      => true,
        chroot_local_user       => true,
        chroot_list_enable      => false,
        file_open_mode          => '0666',
        ftp_data_port           => 20,
        listen                  => true,
        listen_ipv6             => false,
        listen_port             => 21,
        pam_service_name        => 'vsftpd',
        tcp_wrappers            => false,
        allow_writeable_chroot  => true,
        pasv_enable             => true,
        pasv_min_port           => 1024,
        pasv_max_port           => 1048,
        pasv_address            => '127.0.0.1',
        
        userlist_enable         => true,
        userlist_deny           => false,
    }
    
    $config['users'].each |String $userKey, Hash $user| {
        user { "${user['username']}":
            ensure      => present,
            password    => pw_hash( "${user['password']}", 'SHA-512', 'mysalt' ),
            home        => "${user['home']}",
        }
        
        file_line { "vsftpd_user_${user['username']}":
            path    => '/etc/vsftpd/user_list',
            line    => "${user['username']}",
            require => Class['vsftpd'],
        }
    }
}