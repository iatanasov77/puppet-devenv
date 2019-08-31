
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
}
