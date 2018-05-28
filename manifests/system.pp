
class devenv::ssh
{
	# In Puppetfile:
	# mod 'ghoneycutt-ssh', '3.57.0' 
	class { 'ssh':
		sshd_password_authentication	=> 'yes'
	}
	
	# Restatrt sshd service
	file { '/etc/ssh/sshd_config':
		ensure  => present,
		require => Class['ssh'],
	    notify  => Service['sshd']
  	}
}
