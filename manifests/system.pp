
class devenv::ssh
{
	# In Puppetfile:
	# mod 'ghoneycutt-ssh', '3.57.0' 
	class { 'ssh':
		sshd_password_authentication	=> 'yes'
	}

}
