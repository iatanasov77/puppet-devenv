
class devenv::tools
{
	# package install list
	$packages = [
		"mc", 
		"git",
		"git-flow",
		"curl",
		"vim",
		"htop",
		"dos2unix",
	]

	# install packages
	package { $packages:
		ensure => present,
	}
	
	# Install bump version script
	wget::fetch { "Download IAtanasov's bumpversion.php":
		source      => 'https://raw.github.com/iatanasov77/php-dev-tools/develop/bumpversion.php',
		destination => '/usr/local/bin',
		timeout     => 0,
		verbose     => true,
		mode        => '0777',
		execuser    => 'vagrant'
	}
	
	# Install ftp deploy script
	wget::fetch { "Download IAtanasov's bumpversion.php":
		source      => 'https://github.com/iatanasov77/ftp-deployment/releases/download/v2.9/deployment.phar',
		destination => '/usr/local/bin/deploy',
		timeout     => 0,
		verbose     => true,
		mode        => '0777',
		execuser    => 'vagrant'
	}
}
