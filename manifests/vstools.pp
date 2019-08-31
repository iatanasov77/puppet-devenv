
class devenv::vstools
{
	# Install BumpVersion script
	wget::fetch { "Download IAtanasov's bumpversion.php":
		source      => 'https://github.com/iatanasov77/bumpversion/raw/v0.1.0/bumpversion.php',
		destination => '/usr/local/bin/bumpversion',
		timeout     => 0,
		verbose     => true,
		mode        => '0777',
		execuser    => 'vagrant'
	}
	
	# Install MkPhar script
	wget::fetch { "Download IAtanasov's mkphar.php":
		source      => 'https://github.com/iatanasov77/mkphar/raw/v0.1.0/mkphar.php',
		destination => '/usr/local/bin/mkphar',
		timeout     => 0,
		verbose     => true,
		mode        => '0777',
		execuser    => 'vagrant'
	}
	
	# Install VankoSoft MkVhost script
	wget::fetch { "Download VS's mkvhost":
		source      => 'https://github.com/iatanasov77/mkvhost/releases/download/v0.1.0/mkvhost.phar',
		destination => '/usr/local/bin/mkvhost',
		timeout     => 0,
		verbose     => true,
		mode        => '0777',
		execuser    => 'vagrant'
	}
	
	# Install FtpDeploy script
	wget::fetch { "Download ftp-deployment":
		#source      => 'https://github.com/iatanasov77/ftp-deployment/releases/download/v2.9/deployment.phar',
		source      => 'https://github.com/dg/ftp-deployment/releases/download/v3.0.1/deployment.phar',
		destination => '/usr/local/bin/ftpdeploy',
		timeout     => 0,
		verbose     => true,
		mode        => '0777',
		execuser    => 'vagrant'
	}
}
