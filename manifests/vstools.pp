class vs_devenv::vstools (
    Hash $vstools   = {},
) {
	# Install VankoSoft BumpVersion script
	wget::fetch { "Install VankoSoft BumpVersion script":
		source      => "https://github.com/iatanasov77/bumpversion/raw/${vstools['bumpversion']}/bumpversion.php",
		destination => '/usr/local/bin/bumpversion',
		verbose     => true,
		mode        => '0777',
		cache_dir   => '/var/cache/wget',
	}
	
	# Install VankoSoft MkPhar script
	wget::fetch { "Install VankoSoft MkPhar script":
		source      => "https://github.com/iatanasov77/mkphar/raw/${vstools['mkphar']}/mkphar.php",
		destination => '/usr/local/bin/mkphar',
		verbose     => true,
		mode        => '0777',
		cache_dir   => '/var/cache/wget',
	}
	
	# Install VankoSoft MkVhost script
	wget::fetch { "Install VankoSoft MkVhost script":
		source      => "https://github.com/iatanasov77/mkvhost/releases/download/${vstools['mkvhost']}/mkvhost.phar",
		destination => '/usr/local/bin/mkvhost',
		verbose     => true,
		mode        => '0777',
		cache_dir   => '/var/cache/wget',
	}
	
	# Install FtpDeploy script
	if $vstools['ftpdeploy'] == 'download' {
	    wget::fetch { "Install FtpDeploy script":
            source      => "http://download.vankosoft.org/ftpdeploy.phar",
            destination => '/usr/local/bin/ftpdeploy',
            verbose     => true,
            mode        => '0777',
            cache_dir   => '/var/cache/wget',
        }
	} else {
	   wget::fetch { "Install FtpDeploy script":
            #source      => "https://github.com/iatanasov77/ftp-deployment/releases/download/v2.9/deployment.phar",
            source      => "https://github.com/dg/ftp-deployment/releases/download/${vstools['ftpdeploy']}/deployment.phar",
            destination => '/usr/local/bin/ftpdeploy',
            verbose     => true,
            mode        => '0777',
            cache_dir   => '/var/cache/wget',
        }
	}
	
}
