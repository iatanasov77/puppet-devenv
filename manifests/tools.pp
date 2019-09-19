
class devenv::tools
{
    case $operatingsystem 
    {
        'RedHat', 'CentOS', 'Fedora': 
        {
            $gitflow = 'gitflow'
        }
        'Debian', 'Ubuntu':
        {
            $gitflow = 'git-flow'
        }
    }
    
	# package install list
	$packages = [
		"mc", 
		"git",
		"${gitflow}",
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
