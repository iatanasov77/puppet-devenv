# Drush is a command line shell and Unix scripting interface for Drupal. 
###########################################################################
class vs_devenv::drush (
     Array[String] $versions	= ['10',],
  	 String $defaultVersion		= '10',
) {
	# Puppet Dependencies Article: https://blog.mayflower.de/4573-The-Puppet-Anchor-Pattern-in-Practice.html
	# Puppet Drush module: https://github.com/jonhattan/puppet-drush
	class { 'drush' :
        versions		=> $versions,
        default_version	=> $defaultVersion,
    }
}