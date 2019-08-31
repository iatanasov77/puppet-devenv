
class devenv::php
{
	$packages = [
		"php${phpVersion}", 
		"php${phpVersion}-cli",
		"composer",
		"phpunit",
		"libapache2-mod-php${phpVersion}",
		"libapache2-mod-php",
	]
	
	package { $packages:
		ensure => installed
	}
}
